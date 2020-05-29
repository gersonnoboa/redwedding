//
//  MainInteractor.swift
//  RedWedding
//
//  Created by Gerson Noboa on 30.05.2020.
//  Copyright © 2020 Gerson Noboa. All rights reserved.
//

import Foundation

protocol MainInteractorProtocol {
    var presenter: MainPresenterProtocol? { get set }

    func requestEncryption()
}

final class MainInteractor: MainInteractorProtocol {
    var presenter: MainPresenterProtocol?

    func requestEncryption() {
        presenter?.presentEncryptionRequest()
    }
}
