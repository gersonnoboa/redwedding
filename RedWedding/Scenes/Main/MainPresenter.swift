//
//  MainPresenter.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol {
    var viewController: MainViewControllerProtocol? { get set }

    func presentEncryptionRequest()
}

final class MainPresenter: MainPresenterProtocol {
    weak var viewController: MainViewControllerProtocol?

    func presentEncryptionRequest() {
        viewController?.showEncryptionRequest()
    }
}
