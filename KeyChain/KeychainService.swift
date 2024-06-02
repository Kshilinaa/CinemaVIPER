// KeychainService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeychainSwift

/// Для управления хранением токена доступа
class KeychainService {
    // MARK: - Constants

    enum Constants {
        static let tokenKey = "TokenKey"
    }

    // MARK: - Public Properties
    /// Общий экземпляр, для доступа к хранилищу
    static let shared = KeychainService()

    var token: String? {
        get {
            keychain.get(Constants.tokenKey)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: Constants.tokenKey)
            } else {
                keychain.delete(Constants.tokenKey)
            }
        }
    }

    // MARK: - Private Properties
    /// Экземпляр KeychainSwift для взаимодействия с хранилищем ключей
    private let keychain = KeychainSwift()

    // MARK: - Initializers

    private init() {}
}
