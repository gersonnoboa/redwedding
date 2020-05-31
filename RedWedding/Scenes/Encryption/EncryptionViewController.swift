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
}

final class EncryptionViewController: UIViewController, EncryptionViewControllerProtocol {
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

        self.title = "Encrypt"
        setup()
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

    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}
