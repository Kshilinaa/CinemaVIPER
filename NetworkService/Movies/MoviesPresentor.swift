// MoviesPresentor.swift
// Copyright © RoadMap. All rights reserved.

//  MoviesPresentor.swift
//  CinemaStar
// swiftlint:disable all
import Combine
import SwiftData
import UIKit

/// Протокол для взаимодействия с презентером
protocol MoviesPresenterProtocol: ObservableObject {
    /// Стейт для конфигурации вью
    var state: ViewState<[Movie]> { get set }
    /// Передача фильмов с интерактора во вью
    func moviesReceived(_ movies: [Movie])
    /// Заявка на получение фильмов с нетворк сервиса
    func requestMovies(context: ModelContext)
    /// Объявление метода для подготовки фильмов
    func movieInfoUpdated(_ movie: Movie)
    /// Объявление метода для перехода на экран с деталями фильма
    func showMovieDetail(with id: Int)
}

/// Презентер экрана с фильмами
class MoviesPresenter: MoviesPresenterProtocol {
    /// Свойство состояния экрана
    @Published var state: ViewState<[Movie]> = .loading
    /// Свойство ID выбранного фильма для детального просмотра
    @Published var selectedMovieID: Int?
    /// Свойство списка фильмов для хранения
    @Published private var moviesToStore: [SwiftDataMovie] = []

    private var context: ModelContext?
    private var cancellable: AnyCancellable?
    var view: MoviesView?
    var interactor: MoviesInteractorProtocol?
    var router: MoviesRouterProtocol?

    // MARK: - Public Methods

    /// Метод для подготовки фильмов, вызывающий интерактор
    func requestMovies(context: ModelContext) {
        interactor?.receiveMovies()
        self.context = context
    }
    
    /// Метод, вызываемый при получении фильмов
    func moviesReceived(_ movies: [Movie]) {
        state = .data(movies)
    }
    
    /// Метод для обновления информации о фильме
    func movieInfoUpdated(_ movie: Movie) {
        guard case var .data(movies) = state,
              let context = context else { return }
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            state = .data(movies)
            storeMoviesLocally(movies: movies)
        }
    }

    /// Метод для перехода на экран с деталями фильма
    func showMovieDetail(with id: Int) {
        router?.showToDetailScreen(with: self, id: id)
    }

    /// Метод для сохранения фильмов в хранилище
    func storeMoviesLocally(movies: [Movie]) {
        for movie in movies {
            guard let imageData = movie.image?.jpegData(compressionQuality: 0.8) else { return }
            moviesToStore.append(SwiftDataMovie(
                imageUrl: movie.imageUrl ?? "",
                movieName: movie.movieName ?? "",
                rating: movie.rating ?? 0.0,
                id: movie.id,
                image: imageData
            ))
        }
    }

    init() {
        cancellable = $moviesToStore
            .sink { [unowned self] movies in
                for movie in movies
                    where view?.swiftDataStoredMovies.firstIndex(where: { $0.movieID == movie.movieID }) == nil
                {
                    context?.insert(movie)
                }
            }
    }
}

// swiftlint:enable all
