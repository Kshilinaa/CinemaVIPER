// KeychainService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeychainSwift

/// Хранилище для токена
class KeychainService {
    // MARK: - Constants

    enum Constants {
        static let tokenKey = "Token2"
        static let error = "Failed to load token"
    }

    // MARK: - Public Properties

    static let shared = KeychainService()

    func getToken() -> String? {
        if let token = keychain.get(Constants.tokenKey) {
            return token
        } else {
            return nil
        }
    }

    func setToken(token: String) {
        keychain.set(token, forKey: Constants.tokenKey)
    }

    // MARK: - Private Properties

    private let keychain = KeychainSwift()

    // MARK: - Initializers

    private init() {}
}
