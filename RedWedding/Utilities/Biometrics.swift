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
}

final class Biometrics: BiometricsProtocol {
    private let context = LAContext()

    func areBiometricsAvailable() -> Bool {
        return false
        
        let _ = isEnabled()

        switch self.context.biometryType {
        case .touchID, .faceID:
            return true
        default:
            return false
        }
    }

    private func isEnabled() -> Bool {
        return self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
