//
//  MainRouter.swift
//  RedWedding
//
//  Created by Gerson Noboa on 31.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import UIKit

protocol MainRouterProtocol {
    func navigateToEncryption()
}

final class MainRouter: MainRouterProtocol {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { fatalError("Nil navigation controller") }

        self.navigationController = navigationController
    }

    func navigateToEncryption() {
        let encryptionViewController = EncryptionViewController()

        self.navigationController?.pushViewController(encryptionViewController, animated: true)
    }
}
