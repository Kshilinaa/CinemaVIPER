// Builder.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Билдер модулей
enum ViewBuilder {
    /// Метод для создания модуля списка фильмов
    static func buildMoviesModule() -> some View {
        /// Создание презентера для модуля списка фильмов
        let presenter = MoviesPresenter()
        /// Создание интерактора для модуля списка фильмов
        let interactor = MoviesInteractor()
        /// Создание роутера для модуля списка фильмов
        let router = MoviesRouter()
        /// Создание сетевого сервиса для получения данных
        let networkService = NetworkService()
        /// Создание представления для модуля списка фильмов с презентером
        let view = MoviesView(presenter: presenter)
        /// Установка зависимостей презентера
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        /// Установка зависимости интерактора
        interactor.presenter = presenter
        interactor.networkService = networkService
        return view
    }

    /// Метод для создания модуля детального просмотра фильма
    static func buildMoviesDetailModule(id: Int) -> some View {
        /// Создание интерактора для модуля детального просмотра фильма
        let interactor = MovieDetailsInteractor()
        /// Создание презентера для модуля детального просмотра фильма
        let presenter = MovieDetailsPresenter()
        /// Создание роутера для модуля детального просмотра фильма
        let router = MovieDetailsRouter()
        /// Создание сетевого сервиса для получения данных
        let networkService = NetworkService()
        /// Создание представления для модуля детального просмотра фильма с презентером
        var view = MovieDetailsView(presenter: presenter)

        /// Установка ID фильма для детального просмотра
        view.id = id
        /// Установка зависимостей презентера
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        /// Установка зависимости интерактора
        interactor.presenter = presenter
        interactor.networkService = networkService
        return view
    }
}
