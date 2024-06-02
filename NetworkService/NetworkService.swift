// NetworkService.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import UIKit

/// Протокол, описывающий методы для получения данных с сети
protocol NetworkServiceProtocol {
    /// Получает изображение по указанному URL.
    /// - Parameter url: URL изображения.
    /// - Returns: Издатель, который отправляет изображение типа UIImage.
    func receiveImage(from url: URL) -> AnyPublisher<UIImage?, Never>
    /// Получает список фильмов.
    /// - Returns: Издатель, который отправляет DTO с информацией о фильмах.
    func getMovies() -> AnyPublisher<MoviesDTO, Error>
    /// Получает детальную информацию о фильме по его идентификатору.
    /// - Parameter id: Идентификатор фильма.
    /// - Returns: Издатель, который отправляет DTO с информацией о фильме
    func getMovieDetails(by id: Int) -> AnyPublisher<MovieDTO, Error>
}

/// Сервис для работы с сетью
class NetworkService: NetworkServiceProtocol {
    /// Метод для получения списка фильмов
    enum Constants {
        static let baseUrl = "https://api.kinopoisk.dev/v1.4/movie/"
        static let moviesUrl = "https://api.kinopoisk.dev/v1.4/movie/search?query=история"
    }

    /// Метод для получения списка фильмов
    func getMovies() -> AnyPublisher<MoviesDTO, any Error> {
        guard let url = URL(string: Constants.moviesUrl) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        /// Создание запроса с указанием URL и заголовков
        var request = URLRequest(url: url)
        request.setValue("ZY0H144-PF2MNRP-K6JJS5M-55REHHW", forHTTPHeaderField: "X-API-KEY")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MoviesDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// Метод для получения деталей фильма по ID
    func getMovieDetails(by id: Int) -> AnyPublisher<MovieDTO, any Error> {
        guard let url = URL(string: "\(Constants.baseUrl)" + "\(id)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.setValue("ZY0H144-PF2MNRP-K6JJS5M-55REHHW", forHTTPHeaderField: "X-API-KEY")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: MovieDTO.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /// Метод для получения изображения по URL
    func receiveImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
