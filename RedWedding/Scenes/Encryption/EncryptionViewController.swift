//
//  EncryptionViewController.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import UIKit

protocol EncryptionViewControllerProtocol: class {
    var interactor: EncryptionInteractorProtocol? { get set }

    func showAlert(withTitle title: String, message: String)
    func showDecryptedPhrase(_ phrase: String)
    func clearFields()
    func changeButtonsAppearance(encrypt isEncryptedShown: Bool, others areOthersShown: Bool)
}

final class EncryptionViewController: UIViewController {
    @IBOutlet private weak var encryptButton: UIButton!
    @IBOutlet private weak var decryptButton: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var phraseTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    var interactor: EncryptionInteractorProtocol?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Welcome"
        self.passwordTextField.delegate = self

        setup()
        self.interactor?.determineButtonsAppearance()
    }

    private func setup() {
        self.interactor = EncryptionInteractor()

        let presenter = EncryptionPresenter()
        presenter.viewController = self

        self.interactor?.presenter = presenter
    }

    @IBAction func encryptButtonPressed() {
        self.interactor?.requestEncryption(of: self.phraseTextField.text, using: self.passwordTextField.text)
    }

    @IBAction func decryptButtonPressed() {
        self.interactor?.requestDecryption(using: self.passwordTextField.text)
    }

    @IBAction func clearButtonPressed() {
        self.interactor?.requestClear()
    }
}

extension EncryptionViewController: EncryptionViewControllerProtocol {
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }

    func clearFields() {
        self.phraseTextField.text = ""
        self.passwordTextField.text = ""
    }

    func showDecryptedPhrase(_ phrase: String) {
        self.phraseTextField.text = phrase
        self.passwordTextField.resignFirstResponder()
    }

    func changeButtonsAppearance(encrypt isEncryptedShown: Bool, others areOthersShown: Bool) {
        self.encryptButton.isHidden = !isEncryptedShown
        self.decryptButton.isHidden = !areOthersShown
        self.clearButton.isHidden = !areOthersShown
    }
}

extension EncryptionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 < 6
    }
}
