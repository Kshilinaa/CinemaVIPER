// MoviesInteractorTests.swift
// Copyright © RoadMap. All rights reserved.

//
//  MoviesInteractorTests.swift
//  CinemaStarTests
//
//  Created by Ксения Шилина on 31.05.2024.
//
@testable import CinemaStar
import Combine
import SwiftData
import XCTest

/// Моковый сетевой сервис
class MockNetworkService: NetworkServiceProtocol {
    /// Хранение результата запроса фильма
    var fetchMovieResult: Result<MovieDTO, Error>!
    /// Хранение результата запроса списка фильмов
    var fetchMoviesResult: Result<MoviesDTO, Error>!
    /// Хранение результата запроса изображения
    var fetchImageResult: Result<UIImage?, Error>!
    /// Возвращаем результат запроса фильма/
    func fetchMovie(by id: Int) -> AnyPublisher<CinemaStar.MovieDTO, any Error> {
        fetchMovieResult.publisher.eraseToAnyPublisher()
    }
    /// Возвращаем результат запроса списка фильмов/
    func fetchMovies() -> AnyPublisher<MoviesDTO, any Error> {
        fetchMoviesResult.publisher.eraseToAnyPublisher()
    }
    /// Возвращаем результат запроса изображения
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, any Error> {
        fetchImageResult.publisher.eraseToAnyPublisher()
    }
}

/// Моковый презентер
class MockMoviesPresenter: MoviesPresenterProtocol {
    /// Были ли получены фильмы
    var didFetchMovies = false
    /// Для хранения полученных фильмов
    var fetchedMovies: [Movie]?
    func didFetchMovies(_ movies: [Movie]) {
        didFetchMovies = true
        fetchedMovies = movies
    }
}

/// Тесты интерактора фильмов
final class MoviesInteractorTests: XCTestCase {
    var interactor: MoviesInteractor!
    var mockNetworkService: MockNetworkService!
    var mockPresenter: MockMoviesPresenter!
    /// Настройка перед каждым тестом
    override func setUp() {
        super.setUp()
        interactor = MoviesInteractor()
        mockNetworkService = MockNetworkService()
        mockPresenter = MockMoviesPresenter()
        interactor.networkService = mockNetworkService
        interactor.presenter = mockPresenter
    }

    /// Очистка после каждого теста
    override func tearDown() {
        interactor = nil
        mockNetworkService = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testFetchMoviesSuccess() {
        let moviesDTO = MoviesDTO(docs: [
            MovieDTO(
                name: "Бумер",
                id: 66666,
                poster: PosterDTO(url: "https://yandex.ru/images/search/бумер"),
                rating: RatingDTO(kp: 8.3),
                description: "Драмм, криминал",
                year: 2003,
                countries: nil,
                type: nil,
                persons: nil,
                spokenLanguages: nil,
                similarMovies: nil
            ),
            MovieDTO(
                name: "Начало",
                id: 67890,
                poster: PosterDTO(url: "https://example.com/inception_poster"),
                rating: RatingDTO(kp: 7.4),
                description: "Фантастический триллер",
                year: 2010,
                countries: nil,
                type: nil,
                persons: nil,
                spokenLanguages: nil,
                similarMovies: nil
            )
        ])
        /// Создание мокового изображения фильма
        let image = UIImage()
        mockNetworkService.fetchMoviesResult = .success(moviesDTO)
        mockNetworkService.fetchImageResult = .success(image)
        /// Ожидание завершения асинхронной операции/
        let expectation = self.expectation(description: "getMovies")
        interactor.fetchMovies()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(mockPresenter.didFetchMovies)
        XCTAssertEqual(mockPresenter.fetchedMovies?.count, 2)
        XCTAssertEqual(mockPresenter.fetchedMovies?.first?.movieName, "Avengers")
        XCTAssertEqual(mockPresenter.fetchedMovies?.last?.movieName, "Batman")
        XCTAssertEqual(mockPresenter.fetchedMovies?.last?.image, image)
    }

    /// Тест неуспешного получения списка фильмов
    func testFetchMoviesFailure() {
        /// Создание ошибки/
        let error = NSError(domain: "testError", code: 1, userInfo: nil)
        mockNetworkService.fetchMoviesResult = .failure(error)
        /// Ожидание завершения асинхронной операции
        let expectation = self.expectation(description: "getMovies")
        interactor.fetchMovies()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertFalse(mockPresenter.didFetchMovies)
    }
}
