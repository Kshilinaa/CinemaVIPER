// Builder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Контейнер для проставления зависимостей и сборки модулей
final class AppBuilder {
    // MARK: - Public Methods

    /// Модуль списка фильмов
    func makeMoviesScreen(coordinator: BaseCoodinator) -> MoviesViewController {
        let viewModel = MoviesViewModel(coordinator: coordinator)
        let view = MoviesViewController(moviesViewModel: viewModel)
        return view
    }

    /// Модуль деталей фильма
    func makeMovieDetailsScreen(id: Int, coordinator: BaseCoodinator) -> MovieDetailsViewController {
        let viewModel = MovieDetailViewModel(coordinator: coordinator, id: id)
        let view = MovieDetailsViewController(id: id, movieDetailViewModel: viewModel)
        return view
    }
}
