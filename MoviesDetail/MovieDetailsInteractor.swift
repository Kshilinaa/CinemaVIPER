// MoviesDetailInteractor.swift
// Copyright © RoadMap. All rights reserved.

//  MovieDetailsInteractor.swift
//  CinemaStar
//
import Combine
import Foundation

///  Протокол для взаимодействия с интерактором
protocol MovieDetailsInteractorProtocol {
    /// Метод для получения детальной информации о фильме по идентификатору
    /// - Parameter id: Идентификатор фильма
    func fetchMovieDetails(by id: Int)
    /// Изменяет состояние избранного для фильма и сохраняет его в UserDefaults
    /// - Parameters:
    ///   - isFavorite: Флаг, указывающий, является ли фильм избранным или нет
    ///   - id: Идентификатор фильма
    func updateFavoriteState(_ isFavorite: Bool, id: Int)
    /// Получает состояние избранного для фильма из UserDefaults
    /// - Parameter id: Идентификатор фильма
    /// - Returns: Значение true, если фильм находится в списке избранных, в противном случае - false
    func retrieveFavoriteState(id: Int) -> Bool
}

/// Интерактор для  экрана с детальным фильмом
class MovieDetailsInteractor: MovieDetailsInteractorProtocol {
    // MARK: - Types

    /// Презентер, который будет уведомлен о результатах загрузки данных
    var presenter: (any MovieDetailsPresenterProtocol)?
    /// Сетевой сервис для загрузки данных
    var networkService: NetworkServiceProtocol?
    /// Набор для хранения подписок Combine
    var cancellablesSet: Set<AnyCancellable> = []

    // MARK: - Public Methods

    /// Метод для получения детальной информации о фильме по id
    func fetchMovieDetails(by id: Int) {
        networkService?.getMovieDetails(by: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Не удалось найти пользователей: \(error.localizedDescription)")
                }
            }, receiveValue: { [unowned self] movieDTO in
                var movieDetail = MovieDetails(dto: movieDTO)
                if let url = URL(string: movieDetail.imageURL ?? "") {
                    networkService?.receiveImage(from: url)
                        .receive(on: DispatchQueue.main)
                        .sink { image in
                            movieDetail.image = image
                            self.presenter?.handleFetchedMovieDetail(movieDetail)
                        }
                        .store(in: &cancellablesSet)
                }
            })
            .store(in: &cancellablesSet)
    }

    /// Изменяет состояние избранного для фильма и сохраняет его в UserDefaults
    func updateFavoriteState(_ isFavorite: Bool, id: Int) {
        UserDefaults.standard.setValue(isFavorite, forKey: "id_\(id)")
    }

    /// Получает состояние избранного для фильма из UserDefaults
    func retrieveFavoriteState(id: Int) -> Bool {
        UserDefaults.standard.bool(forKey: "id_\(id)")
    }
}
