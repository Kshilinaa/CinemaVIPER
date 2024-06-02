// MoviesDetailInteractorTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import Combine
import SwiftData
import XCTest

/// Моковый презентер
class MockMoviesDetailPresenter: MoviesDetailPresenterProtocol {
    func prepareMovieDetails(by id: Int, context: ModelContext) {}
    /// Были ли получены детали фильма
    var didFetchMovieDetail = false
    /// Переменная для хранения полученных деталей фильма/
    var fetchedMovieDetail: MovieDetail?
    /// Обработка полученных деталей фильма
    func didFetchMovieDetail(_ movieDetail: MovieDetail) {
        didFetchMovieDetail = true
        fetchedMovieDetail = movieDetail
    }
}

/// Тесты интерактора деталей фильма
final class MoviesDetailInteractorTests: XCTestCase {
    var interactor: MoviesDetailInteractor!
    var mockNetworkService: MockNetworkService!
    var mockPresenter: MockMoviesDetailPresenter!
    /// Настройка перед каждым тестом
    override func setUp() {
        super.setUp()
        interactor = MoviesDetailInteractor()
        mockNetworkService = MockNetworkService()
        mockPresenter = MockMoviesDetailPresenter()
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

    /// Тест успешного получения деталей фильма
    func testFetchMovieDetailsSuccess() {
        let movieDTO = MovieDTO(
            name: "Бумер",
            id: 66666,
            poster: PosterDTO(url: "https://yandex.ru/images/search/бумер"),
            rating: RatingDTO(kp: 8.3),
            description: "Драмм, криминал",
            year: 2003,
            countries: nil,
            type: nil,
            persons: [
                PersonDTO(name: "Сергей Бодров", photo: nil)
            ],
            spokenLanguages: nil,
            similarMovies: nil
        )
        /// Создание мокового изображения фильма
        let movieImage = UIImage()
        mockNetworkService.fetchMovieResult = .success(movieDTO)
        mockNetworkService.fetchImageResult = .success(movieImage)
        /// Ожидание завершения асинхронной операции
        let expectation = self.expectation(description: "fetchMovieDetails")
        interactor.fetchMovieDetails(by: 12345)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertTrue(mockPresenter.didFetchMovieDetail)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.year, 2003)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.movieName, "Бумер")
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.image, movieImage)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.movieRating, 8.3)
        XCTAssertEqual(mockPresenter.fetchedMovieDetail?.actors.first?.name, "Сергей Бодров")
    }

    /// Тест неуспешного получения деталей фильма
    func testFetchMovieDetailsFailure() {
        /// Создание ошибки/
        let error = NSError(domain: "testError", code: 1, userInfo: nil)
        mockNetworkService.fetchMovieResult = .failure(error)
        /// Ожидание завершения асинхронной операции
        let expectation = self.expectation(description: "fetchMovieDetails")
        interactor.fetchMovieDetails(by: 12345)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertFalse(mockPresenter.didFetchMovieDetail)
    }
}
