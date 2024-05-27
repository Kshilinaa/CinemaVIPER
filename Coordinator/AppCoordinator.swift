// AppCoordinator.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Главный координатор приложения
final class AppCoordinator: BaseCoodinator {
    // MARK: - Private Properties

    private var appBuilder: AppBuilder

    // MARK: - Initializers

    init(appBuilder: AppBuilder) {
        self.appBuilder = appBuilder
    }

    // MARK: - Public Methods

    override func start() {
        goToMovies()
    }

    func goToMovies() {
        let moviesListModuleView = appBuilder.makeMoviesScreen(coordinator: self)
        rootController = UINavigationController(rootViewController: moviesListModuleView)
        guard let moviesListView = rootController else { return }
        setAsRoot​(​_​: moviesListView)
    }

    func goToMovieDetails(id: Int) {
        let movieDetailModuleView = appBuilder.makeMovieDetailsScreen(
            id: id,
            coordinator: self
        )
        rootController?.pushViewController(movieDetailModuleView, animated: true)
    }

    func backToMoviesList() {
        rootController?.popViewController(animated: true)
    }
}
