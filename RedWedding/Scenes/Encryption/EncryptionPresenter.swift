//
//  EncryptionPresenter.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

protocol EncryptionPresenterProtocol {
    var viewController: EncryptionViewControllerProtocol? { get set }

    func presentEncryptionSuccessfulMessage()
    func presentPhraseEmptyError()
    func presentPasswordWithoutRequirementsError()
    func presentEncryptionError()
}

final class EncryptionPresenter: EncryptionPresenterProtocol {
    weak var viewController: EncryptionViewControllerProtocol?

    func presentEncryptionSuccessfulMessage() {
        self.viewController?.showAlert(withTitle: "Success", message: "Phrase encrypted successfully.")
    }

    func presentPhraseEmptyError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Phrase must not be empty.")
    }

    func presentPasswordWithoutRequirementsError() {
        self.viewController?.showAlert(
            withTitle: "Error",
            message: "Password must not be empty and must be 6 characters long."
        )
    }

    func presentEncryptionError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Error encrypting phrase.")
    }
}
