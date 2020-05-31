//
//  UserDefaultsPersistance.swift
//  RedWedding
//
//  Created by Gerson Noboa on 31.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

enum PersistanceKey: String {
    case encryptedData
}

protocol PersistanceProtocol {
    func save(_ data: Data, usingKey key: PersistanceKey) -> Bool
    func load(usingKey key: PersistanceKey) -> Data?
    func clear(usingKey key: PersistanceKey) -> Bool
}

final class KeychainPersistance: PersistanceProtocol {
    func save(_ data: Data, usingKey key: PersistanceKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data]
        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func load(usingKey key: PersistanceKey) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)

        guard status == errSecSuccess else { return nil }

        return data as? Data
    }

    func clear(usingKey key: PersistanceKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }
}
