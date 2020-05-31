//
//  EncryptionPresenter.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

enum EncryptButtonsAppearance {
    case encryptOnly
    case decryptAndClear
}

protocol EncryptionPresenterProtocol {
    var viewController: EncryptionViewControllerProtocol? { get set }

    func presentButtonsAppearance(_ appearance: EncryptButtonsAppearance)
    func presentEncryptedSuccessfully()
    func presentPhraseEmptyError()
    func presentPasswordWithoutRequirementsError()
    func presentEncryptionError()
    func presentDecryptionError()
    func presentDecryptedPhrase(_ phrase: String)
    func presentIncorrectPasswordError()
    func presentClearSuccessfully()
    func presentEmptyFields()
}

final class EncryptionPresenter: EncryptionPresenterProtocol {
    weak var viewController: EncryptionViewControllerProtocol?

    func presentButtonsAppearance(_ appearance: EncryptButtonsAppearance) {
        switch appearance {
        case .encryptOnly:
            self.viewController?.changeButtonsAppearance(encrypt: true, others: false)
        case .decryptAndClear:
            self.viewController?.changeButtonsAppearance(encrypt: false, others: true)
        }
    }
    func presentEncryptedSuccessfully() {
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

    func presentDecryptionError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Error decrypting phrase.")
    }

    func presentIncorrectPasswordError() {
        self.viewController?.showAlert(withTitle: "Error", message: "Incorrect password.")
    }

    func presentDecryptedPhrase(_ phrase: String) {
        self.viewController?.showDecryptedPhrase(phrase)
    }

    func presentClearSuccessfully() {
        self.viewController?.showAlert(withTitle: "Success", message: "Data cleared successfully.")
    }

    func presentEmptyFields() {
        self.viewController?.clearFields()
    }
}
