// MoviesInteractor.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import SwiftData
import SwiftUI

/// Протокол для взаимодействия с интерактором
protocol MoviesInteractorProtocol {
    func receiveMovies()
}

/// Интерактор экрана с фильмами
class MoviesInteractor: MoviesInteractorProtocol {
    // MARK: - Types

    /// Презентер для обновления вью
    var presenter: (any MoviesPresenterProtocol)?
    /// Сервис для работы с сетью
    var networkService: NetworkServiceProtocol?
    /// Набор для хранения подписок Combine
    var cancellablesSet: Set<AnyCancellable> = []

    // MARK: - Public Methods

    /// Функция для получения списка фильмов
    func receiveMovies() {
        networkService?.getMovies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Failed to fetch users: \(error.localizedDescription)")
                }
            }, receiveValue: { [unowned self] moviesDTO in
                let movies = moviesDTO.docs.map { dto -> Movie in
                    var movie = Movie(dto: dto)
                    if let url = URL(string: movie.imageUrl ?? "") {
                        networkService?.receiveImage(from: url)
                            .receive(on: DispatchQueue.main)
                            .sink { [unowned self] image in
                                movie.image = image
                                presenter?.movieInfoUpdated(movie)
                            }
                            .store(in: &cancellablesSet)
                    }
                    return movie
                }
                presenter?.moviesReceived(movies)

            })
            .store(in: &cancellablesSet)
    }
}
