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
    func save(_ data: Data, usingKey key: PersistanceKey)
    func load(usingKey key: PersistanceKey) -> Any?
}

final class UserDefaultsPersistance: PersistanceProtocol {
    var userDefaults: UserDefaults = UserDefaults.standard

    func save(_ data: Data, usingKey key: PersistanceKey) {
        self.userDefaults.set(data, forKey: key.rawValue)
    }

    func load(usingKey key: PersistanceKey) -> Any? {
        self.userDefaults.value(forKey: key.rawValue)
    }
}
