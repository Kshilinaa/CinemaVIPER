// MovieDetailsPresenter.swift
// Copyright © RoadMap. All rights reserved.

//  MovieDetailsPresenter.swift
//  CinemaStar
//
import Combine
import Foundation
import SwiftData

///  Протокол для взаимодействия с презентером
protocol MovieDetailsPresenterProtocol: ObservableObject {
    /// Подготовка детальной информации о фильме по идентификатору
    /// - Parameters:
    ///   - id: Идентификатор фильма
    ///   - context: Контекст модели для сохранения данных
    func initializeMovieDetails(by id: Int, context: ModelContext)
    /// Метод, вызываемый при успешной загрузке данных о фильме
    /// - Parameter movie: Детальная информация о фильме
    func handleFetchedMovieDetail(_ movie: MovieDetails)
    /// Изменение состояния "Избранное" для фильма
    /// - Parameters:
    ///   - isFavorite: Флаг, указывающий на состояние "Избранное"
    ///   - id: Идентификатор фильма
    func toggleFavoriteState(_ isFavorite: Bool, id: Int)
    /// Получение состояния "Избранное" для фильма
    /// - Parameter id: Идентификатор фильма
    /// - Returns: Флаг, указывающий на состояние "Избранное"
    func retrieveFavoriteState(id: Int) -> Bool
}

/// Презентер для  экрана с детальным фильмом
class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    /// Состояние, использующееся для обновления UI
    @Published var state: ViewState<MovieDetails> = .loading
    /// Контекст модели для сохранения данных
    private var context: ModelContext?
    /// Представление, которое отображает детальную информацию о фильме
    var view: MovieDetailsView?
    /// Интерактор для получения данных о фильме
    var interactor: MovieDetailsInteractorProtocol?
    /// Роутер для навигации
    var router: MovieDetailsRouterProtocol?

    // MARK: - Public Methods

    /// Изменяет состояние избранного для фильма
    func toggleFavoriteState(_ isFavorite: Bool, id: Int) {
        interactor?.updateFavoriteState(isFavorite, id: id)
    }

    /// Получает состояние избранного для фильма
    func retrieveFavoriteState(id: Int) -> Bool {
        guard let interactor else { return false }
        return interactor.retrieveFavoriteState(id: id)
    }

    /// Подготавливает детали фильма по идентификатору и контексту
    func initializeMovieDetails(by id: Int, context: ModelContext) {
        interactor?.fetchMovieDetails(by: id)
        self.context = context
    }

    /// Обрабатывает полученные детали фильма
    func handleFetchedMovieDetail(_ movie: MovieDetails) {
        state = .data(movie)
        saveToContext(movie: movie)
    }

    /// Сохранение детальной информации о фильме
    func saveToContext(movie: MovieDetails) {
        guard let imageData = movie.image?.jpegData(compressionQuality: 0.8),
              let context = context,
              view?.movieDetail.firstIndex(where: { $0.movieID == movie.movieID }) == nil else { return }
        context.insert(SwiftDataMovieDetail(
            movieName: movie.movieName,
            movieRating: movie.movieRating,
            imageURL: movie.imageURL,
            id: movie.movieID,
            description: movie.description,
            year: movie.year,
            country: movie.country,
            contentType: movie.genreFilm,
            actors: movie.actors,
            language: movie.language,
            similarMovies: movie.similarMovies,
            image: imageData
        ))
    }
}
