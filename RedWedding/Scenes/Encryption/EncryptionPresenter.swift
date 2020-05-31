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
}

final class EncryptionPresenter: EncryptionPresenterProtocol {
    weak var viewController: EncryptionViewControllerProtocol?
}
