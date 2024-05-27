// APIRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Шаблон запроса в сеть
class APIRequest<Resource: APIResource> {
    let resource: Resource

    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Resource.ModelType.self, from: data)
    }

    func execute(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}
