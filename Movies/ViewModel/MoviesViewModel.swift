// MoviesViewModel.swift
// Copyright © RoadMap. All rights reserved.

/// Протокол вью-модели для экрана списка фильмов
protocol MoviesViewModelProtocol {
    /// Переход на экран деталей фильма
    func moveToMovieDetailScreen(id: Int)
    /// Получение фильмов с сети
    func fetchMovies(completion: @escaping VoidHandler)
    var state: ModelViewState<[Movie]> { get set }
}

/// Вью модель для экрана списка фильмов
final class MoviesViewModel: MoviesViewModelProtocol {
    // MARK: - Properties

    let coordinator: BaseCoodinator
    var movies: [Movie] = []
    var state: ModelViewState<[Movie]>
    private var moviesRequest: APIRequest<MovieResource>?

    // MARK: - Initializers

    init(coordinator: BaseCoodinator) {
        self.coordinator = coordinator
        state = .loading
    }

    // MARK: - Public Methods]

    func fetchMovies(completion: @escaping VoidHandler) {
        let resource = MovieResource()
        let request = APIRequest(resource: resource)
        moviesRequest = request
        request.execute { [weak self] data in
            guard let fetchedMovies = data?.docs else { return }
            for movie in fetchedMovies {
                self?.movies.append(Movie(dto: movie))
            }
            guard let movies = self?.movies else { return }
            self?.state = .data(movies)
            print(movies)
            completion()
        }
    }

    func moveToMovieDetailScreen(id: Int) {
        guard let appCoordinator = coordinator as? AppCoordinator else { return }
        appCoordinator.goToMovieDetails(id: id)
    }
}
