//
//  UserDefaultsPersistance.swift
//  RedWedding
//
//  Created by Gerson Noboa on 31.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

enum PersistanceKey: String {
    case encryptedPhrase, encryptedPassword
}

protocol PersistanceProtocol {
    func save(_ data: Data, usingKey key: PersistanceKey, needsBiometric: Bool) -> Bool
    func load(usingKey key: PersistanceKey, needsBiometric: Bool, completion: @escaping ((Data?) -> Void))
    func clear(usingKey key: PersistanceKey)
}

final class KeychainPersistance: PersistanceProtocol {
    var biometrics: BiometricsProtocol = Biometrics()
    
    private lazy var access: SecAccessControl? = {
        return SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            nil
        )
    }()

    func save(_ data: Data, usingKey key: PersistanceKey, needsBiometric: Bool) -> Bool {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data]

        if needsBiometric {
            query[kSecAttrAccessControl as String] = self.access
        }

        let status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func load(usingKey key: PersistanceKey, needsBiometric: Bool, completion: @escaping ((Data?) -> Void)) {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        if needsBiometric {
            query[kSecAttrAccessControl as String] = self.access
            query[kSecUseOperationPrompt as String] = "Decrypt by using your stored password in the keychain."
        }
        
        var data: CFTypeRef?
        DispatchQueue.global().async {
            let status = SecItemCopyMatching(query as CFDictionary, &data)

            DispatchQueue.main.async {
                guard status == errSecSuccess else {
                    completion(nil)

                    return
                }

                completion(data as? Data)
            }
        }
    }

    func clear(usingKey key: PersistanceKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
}
