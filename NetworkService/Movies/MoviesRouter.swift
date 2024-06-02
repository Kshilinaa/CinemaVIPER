// MoviesRouter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для навигации к экрану с деталями фильма
protocol MoviesRouterProtocol {
    /// Метод для перехода к деталям фильма
    func showToDetailScreen(with presenter: MoviesPresenter, id: Int)
}

/// Роутер экрана с фильмами
class MoviesRouter: MoviesRouterProtocol {
    /// Метод для навигации к экрану с деталями фильма
    func showToDetailScreen(with presenter: MoviesPresenter, id: Int) {
        presenter.selectedMovieID = id
    }
}
