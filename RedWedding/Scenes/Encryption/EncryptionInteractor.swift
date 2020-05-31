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
        let hasNoEncryptedData = self.persistance.load(usingKey: .encryptedData, needsBiometric: false) == nil

        hasNoEncryptedData ?
            self.presenter?.presentButtonsAppearance(.encryptOnly) :
            self.presenter?.presentButtonsAppearance(.decryptAndClear)
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

        if self.biometrics.isEnabled() {
            guard hasEncryptedPasswordSuccessfully(password) else {
                self.presenter?.presentEncryptionError()
                let _ = self.persistance.clear(usingKey: .encryptedData)

                return
            }
        }

        executeEncryptionSuccess()
    }

    private func hasEncryptedPhraseSuccessfully(_ phrase: String, using password: String) -> Bool {
        let data = self.encryption.encrypt(phrase, using: password)

        return self.persistance.save(data, usingKey: .encryptedData, needsBiometric: false)
    }

    private func hasEncryptedPasswordSuccessfully(_ password: String) -> Bool {
        let data = self.encryption.encrypt(password, using: passwordForPassword)

        return self.persistance.save(data, usingKey: .encryptedPassword, needsBiometric: true)
    }

    private func executeEncryptionSuccess() {
        self.presenter?.presentEncryptedSuccessfully()
        self.presenter?.presentEmptyFields()
        self.determineButtonsAppearance()
    }

    func requestDecryption(using password: String?) {
        guard let password = password, password.count == passwordLength else {
            self.presenter?.presentIncorrectPasswordError()
            return
        }

        guard let data = self.persistance.load(usingKey: .encryptedData, needsBiometric: false) else {
            self.presenter?.presentDecryptionError()
            return
        }

        do {
            guard let decryptedData = try self.encryption.decrypt(data, using: password),
                let phrase = String(bytes: decryptedData, encoding: .utf8) else {
                self.presenter?.presentDecryptionError()
                return
            }

            self.presenter?.presentDecryptedPhrase(phrase)
        }
        catch RNCryptor.Error.hmacMismatch {
            self.presenter?.presentIncorrectPasswordError()
        }
        catch {
            self.presenter?.presentDecryptionError()
        }
    }

    func requestClear() {
        let isClearSuccessful = self.persistance.clear(usingKey: .encryptedData) &&
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
