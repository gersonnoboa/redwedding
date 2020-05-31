//
//  EncryptionInteractor.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

protocol EncryptionInteractorProtocol {
    var presenter: EncryptionPresenterProtocol? { get set }
}

final class EncryptionInteractor: EncryptionInteractorProtocol {
    var presenter: EncryptionPresenterProtocol?
}
