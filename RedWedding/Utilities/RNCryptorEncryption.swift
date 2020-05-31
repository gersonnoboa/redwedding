//
//  RNCryptorEncryption.swift
//  RedWedding
//
//  Created by Gerson Noboa on 31.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation
import RNCryptor

protocol EncryptionProtocol {
    func encrypt(_ string: String, using password: String) -> Data
    func decrypt(_ data: Data, using password: String) throws -> Data?
}

final class RNCryptorEncryption: EncryptionProtocol {
    func encrypt(_ string: String, using password: String) -> Data {
        let data = Data(string.utf8)
        let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)

        return encryptedData
    }

    func decrypt(_ data: Data, using password: String) throws -> Data? {
        do {
            return try RNCryptor.decrypt(data: data, withPassword: password)
        }
        catch {
            throw error
        }
    }
}
