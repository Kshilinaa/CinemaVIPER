// NetworkRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation
import KeychainSwift

/// Шаблон для загрузки данных с сети и их обработки
protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL?, withCompletion completion: @escaping (ModelType?) -> Void) {
        guard let url = url else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        var request = URLRequest(url: url)
        guard let token = KeychainService.shared.getToken() else { return }
        request.setValue(token, forHTTPHeaderField: "X-API-KEY")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion(value)
            }
        }
        task.resume()
    }
}
