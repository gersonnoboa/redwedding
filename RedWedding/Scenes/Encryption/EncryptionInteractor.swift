//
//  EncryptionInteractor.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

protocol EncryptionInteractorProtocol {
    var presenter: EncryptionPresenterProtocol? { get set }

    func requestEncryption(of phrase: String?, using password: String?)
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
}
