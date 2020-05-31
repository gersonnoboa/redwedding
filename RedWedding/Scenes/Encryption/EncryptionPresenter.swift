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
    func presentDecryptedPhrase(_ phrase: String)
    func presentClearSuccessfully()
    func presentEmptyFields()

    func presentPhraseEmptyError()
    func presentPasswordWithoutRequirementsError()
    func presentEncryptionError()
    func presentDecryptionError()
    func presentIncorrectPasswordError()
}

final class EncryptionPresenter: EncryptionPresenterProtocol {
    private let error = "Error"
    private let success = "Success"

    weak var viewController: EncryptionViewControllerProtocol?
}

extension EncryptionPresenter {
    func presentButtonsAppearance(_ appearance: EncryptButtonsAppearance) {
        switch appearance {
        case .encryptOnly:
            self.viewController?.changeButtonsAppearance(encrypt: true, others: false)
        case .decryptAndClear:
            self.viewController?.changeButtonsAppearance(encrypt: false, others: true)
        }
    }

    func presentEncryptedSuccessfully() {
        self.viewController?.showAlert(withTitle: success, message: "Phrase encrypted successfully.")
    }

    func presentDecryptedPhrase(_ phrase: String) {
        self.viewController?.showDecryptedPhrase(phrase)
    }

    func presentClearSuccessfully() {
        self.viewController?.showAlert(withTitle: success, message: "Data cleared successfully.")
    }

    func presentEmptyFields() {
        self.viewController?.clearFields()
    }
}

extension EncryptionPresenter {
    func presentPhraseEmptyError() {
        self.viewController?.showAlert(withTitle: error, message: "Phrase must not be empty.")
    }

    func presentPasswordWithoutRequirementsError() {
        self.viewController?.showAlert(
            withTitle: error,
            message: "Password must not be empty and must be 6 characters long."
        )
    }

    func presentEncryptionError() {
        self.viewController?.showAlert(withTitle: error, message: "Error encrypting phrase.")
    }

    func presentDecryptionError() {
        self.viewController?.showAlert(withTitle: error, message: "Error decrypting phrase.")
    }

    func presentIncorrectPasswordError() {
        self.viewController?.showAlert(withTitle: error, message: "Incorrect password.")
    }
}
