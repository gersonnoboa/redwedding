//
//  Biometrics.swift
//  RedWedding
//
//  Created by Gerson Noboa on 31.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import LocalAuthentication

protocol BiometricsProtocol {
    func areBiometricsAvailable() -> Bool
    func isEnabled() -> Bool
}

final class Biometrics: BiometricsProtocol {
    private let authContext = LAContext()

    func areBiometricsAvailable() -> Bool {
        let _ = isEnabled()

        switch authContext.biometryType {
        case .touchID, .faceID:
            return true
        default:
            return false
        }
    }

    func isEnabled() -> Bool {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
