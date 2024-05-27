// DetailsMovieViewModel.swift
// Copyright © RoadMap. All rights reserved.

/// Интерфейс вью моделя для экрана списка фильмов
protocol MovieDetailViewModelProtocol {
    /// Состояние данных
    var state: ModelViewState<MovieDetail> { get set }
    /// Получение фильма с сети
    func fetchMovie(completion: @escaping VoidHandler)
    /// Получение изображения фильма с сети
    func backToMoviesList()
}

/// Вью модель для экрана списка фильмов
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: - Public Properties

    var state: ModelViewState<MovieDetail>

    // MARK: - Private Properties

    private let coordinator: BaseCoodinator
    private var id: Int
    private var request: APIRequest<MovieDetailResource>?

    // MARK: - Initializers

    init(coordinator: BaseCoodinator, id: Int) {
        self.coordinator = coordinator
        self.id = id
        state = .loading
    }

    // MARK: - Public Methods

    /// Получение фильма с сети
    func fetchMovie(completion: @escaping VoidHandler) {
        let resource = MovieDetailResource(id: id)
        let request = APIRequest(resource: resource)
        self.request = request
        request.execute { [weak self] movie in
            guard let fetchedMovie = movie else { return }
            self?.state = .data(MovieDetail(dto: fetchedMovie))
            completion()
        }
    }

    /// Возврат к списку фильмов
    func backToMoviesList() {
        guard let coordinator = coordinator as? AppCoordinator else { return }
        coordinator.backToMoviesList()
    }
}
