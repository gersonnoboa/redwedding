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
    var router: MainRouterProtocol?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        self.interactor = MainInteractor()

        let presenter = MainPresenter()
        presenter.viewController = self
        
        interactor?.presenter = presenter

        let bla = MainRouter(navigationController: self.navigationController)
        self.router = bla
    }

    @IBAction func encryptButtonPressed() {
        self.router?.navigateToEncryption()
    }

    func showEncryptionRequest() {

    }
}

