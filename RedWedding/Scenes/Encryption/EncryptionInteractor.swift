//
//  EncryptionInteractor.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation
import RNCryptor

protocol EncryptionInteractorProtocol {
    var presenter: EncryptionPresenterProtocol? { get set }

    func requestEncryption(of phrase: String?, using password: String?)
    func requestDecryption(using password: String?)
    func requestClear()
    func determineButtonsAppearance()
}

final class EncryptionInteractor: EncryptionInteractorProtocol {
    private let passwordForPassword = "Password's password"

    var presenter: EncryptionPresenterProtocol?
    var encryption: EncryptionProtocol = RNCryptorEncryption()
    var persistance: PersistanceProtocol = KeychainPersistance()
    var biometrics: BiometricsProtocol = Biometrics()

    static let passwordLength = 6

    func determineButtonsAppearance() {
        self.persistance.load(usingKey: .encryptedPhrase, needsBiometric: false) { [weak self] data in
            data == nil ?
                self?.presenter?.presentButtonsAppearance(.encryptOnly) :
                self?.presenter?.presentButtonsAppearance(.decryptAndClear)
        }
    }

    func requestEncryption(of phrase: String?, using password: String?) {
        guard let phrase = phrase, !phrase.isEmpty else {
            self.presenter?.presentPhraseEmptyError()
            return
        }

        guard let password = password, password.count == EncryptionInteractor.passwordLength else {
            self.presenter?.presentPasswordWithoutRequirementsError()
            return
        }

        guard hasEncryptedPhraseSuccessfully(phrase, using: password) else {
            self.presenter?.presentEncryptionError()
            return
        }

        if self.biometrics.areBiometricsAvailable() {
            encryptPasswordWithBiometrics(password)
        }
        else {
            executeEncryptionSuccess()
        }
    }

    func requestDecryption(using password: String?) {
        if self.biometrics.areBiometricsAvailable() {
            decryptPhraseWithBiometrics(fallbackPassword: password)
        }
        else {
            decryptPhraseWithPassword(password)
        }
    }

    func requestClear() {
        self.persistance.clear(usingKey: .encryptedPhrase)
        self.persistance.clear(usingKey: .encryptedPassword)

        self.presenter?.presentClearSuccessfully()
        self.presenter?.presentEmptyFields()
        self.determineButtonsAppearance()
    }
}

extension EncryptionInteractor {
    private func hasEncryptedPhraseSuccessfully(_ phrase: String, using password: String) -> Bool {
        let data = self.encryption.encrypt(phrase, using: password)

        return self.persistance.save(data, usingKey: .encryptedPhrase, needsBiometric: false)
    }

    private func encryptPasswordWithBiometrics(_ password: String) {
        let data = self.encryption.encrypt(password, using: passwordForPassword)

        guard self.persistance.save(data, usingKey: .encryptedPassword, needsBiometric: true) else {
            self.presenter?.presentEncryptionError()
            let _ = self.persistance.clear(usingKey: .encryptedPhrase)

            return
        }

        executeEncryptionSuccess()
    }

    private func executeEncryptionSuccess() {
        self.presenter?.presentEncryptedSuccessfully()
        self.presenter?.presentEmptyFields()
        self.determineButtonsAppearance()
    }

    private func decryptPhraseWithBiometrics(fallbackPassword: String?) {
        self.persistance.load(usingKey: .encryptedPassword, needsBiometric: true) { [weak self] data in
            guard let self = self else { return }

            guard let data = data else {
                self.decryptPhraseWithPassword(fallbackPassword)
                return
            }

            guard let password = self.tryDecryption(using: data, password: self.passwordForPassword) else { return }

            self.decryptPhrase(using: password)
        }
    }

    private func decryptPhraseWithPassword(_ password: String?) {
        guard let password = password, password.count == EncryptionInteractor.passwordLength else {
            self.presenter?.presentIncorrectPasswordError()
            return
        }

        decryptPhrase(using: password)
    }

    private func decryptPhrase(using password: String) {
        self.persistance.load(usingKey: .encryptedPhrase, needsBiometric: false) { [weak self] data in
            guard let data = data else {
                self?.presenter?.presentDecryptionError()
                return
            }

            guard let phrase = self?.tryDecryption(using: data, password: password) else { return }

            self?.presenter?.presentDecryptedPhrase(phrase)
        }
    }

    private func tryDecryption(using data: Data, password: String) -> String? {
        do {
            guard let decryptedData = try self.encryption.decrypt(data, using: password),
                let string = String(bytes: decryptedData, encoding: .utf8) else {
                self.presenter?.presentDecryptionError()
                return nil
            }

            return string
        }
        catch RNCryptor.Error.hmacMismatch {
            self.presenter?.presentIncorrectPasswordError()
            return nil
        }
        catch {
            self.presenter?.presentDecryptionError()
            return nil
        }
    }
}
