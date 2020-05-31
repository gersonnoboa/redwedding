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
    func encrypt(_ string: String, using password: String) -> Data?
    func decrypt(_ data: Data, using password: String) throws -> Data?
}

final class RNCryptorEncryption: EncryptionProtocol {
    func encrypt(_ string: String, using password: String) -> Data? {
        guard let data = Data(base64Encoded: string) else { return nil }

        return RNCryptor.encrypt(data: data, withPassword: password)
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
