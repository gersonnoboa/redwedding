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
}

final class EncryptionViewController: UIViewController, EncryptionViewControllerProtocol {
    var interactor: EncryptionInteractorProtocol?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Encrypt/Decrypt"
        setup()
    }

    private func setup() {
        self.interactor = EncryptionInteractor()

        let presenter = EncryptionPresenter()
        presenter.viewController = self

        self.interactor?.presenter = presenter
    }
}
