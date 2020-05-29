//
//  MainViewController.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import UIKit

protocol MainViewControllerProtocol: class {
    var interactor: MainInteractorProtocol? { get set }

    func showEncryptionRequest()
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    @IBOutlet weak var encryptButton: UIButton!

    var interactor: MainInteractorProtocol?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        self.interactor = MainInteractor()

        let presenter = MainPresenter()
        presenter.viewController = self
        
        interactor?.presenter = presenter
    }

    @IBAction func encryptButtonPressed() {
        interactor?.requestEncryption()
    }

    func showEncryptionRequest() {
        print("Works")
    }
}

