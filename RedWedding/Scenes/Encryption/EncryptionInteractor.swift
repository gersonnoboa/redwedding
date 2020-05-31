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
}

final class EncryptionInteractor: EncryptionInteractorProtocol {
    var presenter: EncryptionPresenterProtocol?
    var encryption: EncryptionProtocol = RNCryptorEncryption()
    var persistance: PersistanceProtocol = UserDefaultsPersistance()

    func requestEncryption(of phrase: String?, using password: String?) {
        guard let phrase = phrase, !phrase.isEmpty else {
            self.presenter?.presentPhraseEmptyError()

            return
        }

        guard let password = password, password.count == 6 else {
            self.presenter?.presentPasswordWithoutRequirementsError()

            return
        }
        
        let data = self.encryption.encrypt(phrase, using: password)
        self.persistance.save(data, usingKey: .encryptedData)

        self.presenter?.presentEncryptionSuccessfulMessage()
    }

    func requestDecryption(using password: String?) {
        guard let password = password else {
            self.presenter?.presentPasswordEmptyError()

            return
        }

        guard let data = self.persistance.load(usingKey: .encryptedData) as? Data else {
                self.presenter?.presentDecryptionError()

                return
        }

        do {
            let decryptedData = try self.encryption.decrypt(data, using: password)

            guard let decData = decryptedData, let phrase = String(bytes: decData, encoding: .utf8) else {
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
}
