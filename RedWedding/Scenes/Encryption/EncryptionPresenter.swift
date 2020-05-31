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
    func presentPasswordEmptyError()
    func presentDecryptionError()
    func presentDecryptedPhrase(_ phrase: String)
    func presentIncorrectPasswordError()
}

final class EncryptionPresenter: EncryptionPresenterProtocol {
    weak var viewController: EncryptionViewControllerProtocol?

    func presentEncryptionSuccessfulMessage() {
        self.viewController?.showAlert(withTitle: "Success", message: "Phrase encrypted successfully.")
        self.viewController?.clearFields()
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

    func presentPasswordEmptyError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Password must not be empty.")
    }

    func presentDecryptionError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Error decrypting phrase.")
    }

    func presentIncorrectPasswordError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Incorrect password.")
    }

    func presentDecryptedPhrase(_ phrase: String) {
        self.viewController?.showDecryptedPhrase(phrase)
    }
}
