// APIResource.swift
// Copyright © RoadMap. All rights reserved.

//
//  APIResource.swift
//  CinemaStar
//
import Foundation

protocol APIResource {
    associatedtype ModelType: Decodable
    var path: String { get }
}

extension APIResource {
    var url: URL? {
        var components = URLComponents(string: "https://api.kinopoisk.dev/v1.4/movie") ?? URLComponents()
        components.path += path
        if path == "/search" {
            components.queryItems = [URLQueryItem(name: "query", value: "История")]
        }
        return components.url
    }
}

/// Ресурс для поиска всех фильмов
struct MovieResource: APIResource {
    typealias ModelType = MoviesDTO

    var path = "/search"
}

/// Ресурс для поиска конкретного фильма
struct MovieDetailResource: APIResource {
    typealias ModelType = MovieDTO

    var id: Int?

    var path: String {
        guard let id = id else {
            return ""
        }
        return "/\(id)"
    }
}
