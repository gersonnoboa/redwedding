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

    private let passwordLength = 6

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

        guard let password = password, password.count == passwordLength else {
            self.presenter?.presentPasswordWithoutRequirementsError()
            return
        }

        guard hasEncryptedPhraseSuccessfully(phrase, using: password) else {
            self.presenter?.presentEncryptionError()
            return
        }

        if self.biometrics.areBiometricsAvailable() {
            let data = self.encryption.encrypt(password, using: passwordForPassword)

            guard self.persistance.save(data, usingKey: .encryptedPassword, needsBiometric: true) else {
                self.presenter?.presentEncryptionError()
                let _ = self.persistance.clear(usingKey: .encryptedPhrase)

                return
            }

            executeEncryptionSuccess()
        }
        else {
            executeEncryptionSuccess()
        }
    }

    func requestDecryption(using password: String?) {
        if self.biometrics.areBiometricsAvailable() {
            decryptWithBiometrics()
        }
        else {
            decryptWithPassword(password)
        }
    }

    func requestClear() {
        let isClearSuccessful = self.persistance.clear(usingKey: .encryptedPhrase) &&
            self.persistance.clear(usingKey: .encryptedPassword)

        if isClearSuccessful {
            self.presenter?.presentClearSuccessfully()
            self.presenter?.presentEmptyFields()
            self.determineButtonsAppearance()
        }
        else {
            self.presenter?.presentClearError()
        }
    }
}

extension EncryptionInteractor {
    private func hasEncryptedPhraseSuccessfully(_ phrase: String, using password: String) -> Bool {
        let data = self.encryption.encrypt(phrase, using: password)

        return self.persistance.save(data, usingKey: .encryptedPhrase, needsBiometric: false)
    }

    private func executeEncryptionSuccess() {
        self.presenter?.presentEncryptedSuccessfully()
        self.presenter?.presentEmptyFields()
        self.determineButtonsAppearance()
    }

    private func decryptWithBiometrics() {
        self.persistance.load(usingKey: .encryptedPassword, needsBiometric: true) { [weak self] data in
            guard let self = self else { return }

            guard let data = data else {
                self.presenter?.presentDecryptionError()
                return
            }

            do {
                guard let decryptedData = try self.encryption.decrypt(data, using: self.passwordForPassword),
                    let password = String(bytes: decryptedData, encoding: .utf8) else {
                    self.presenter?.presentDecryptionError()
                    return
                }

                self.decryptPhrase(using: password)
            }
            catch {
                self.presenter?.presentDecryptionError()
            }
        }
    }

    private func decryptWithPassword(_ password: String?) {
        guard let password = password, password.count == passwordLength else {
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

            do {
                guard let decryptedData = try self?.encryption.decrypt(data, using: password),
                    let phrase = String(bytes: decryptedData, encoding: .utf8) else {
                    self?.presenter?.presentDecryptionError()
                    return
                }

                self?.presenter?.presentDecryptedPhrase(phrase)
            }
            catch RNCryptor.Error.hmacMismatch {
                self?.presenter?.presentIncorrectPasswordError()
            }
            catch {
                self?.presenter?.presentDecryptionError()
            }
        }
    }
}
