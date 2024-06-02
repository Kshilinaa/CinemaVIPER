// MoviesView.swift
// Copyright © RoadMap. All rights reserved.

import Combine
import SwiftData
import SwiftUI

/// Структура экрана с фильмами
struct MoviesView: View {
    // MARK: - Constants

    enum Constants {
        static let errorTitle = "Error"
        static let seeTitle = "Смотри исторические\nфильмы на "
        static let cinemaStarTitle = "CINEMA STAR"
    }

    /// Презентер для управления состоянием экрана
    @StateObject var presenter: MoviesPresenter
    /// Запрос для получения сохраненных фильмов из SwiftData
    @Query var swiftDataStoredMovies: [SwiftDataMovie]
    /// Контекст модели для взаимодействия с данными
    @Environment(\.modelContext) var context

    // MARK: - Body

    var body: some View {
        NavigationStack {
            backgroundStackView(color: gradientColor) {
                content
                    .environmentObject(presenter)
                    .background(navigationLinkView)
                    .onAppear {
                        onAppear()
                    }
            }
        }
    }

    // MARK: - Private Properties

    private var content: some View {
        VStack {
            switch presenter.state {
            case .loading:
                Text("")
            case let .data(fetchedMovies):
                if fetchedMovies.isEmpty {
                    MoviesCollectionView(swiftDataMovies: swiftDataStoredMovies)
                } else {
                    MoviesCollectionView(movies: fetchedMovies)
                }
            case .error:
                Text(Constants.errorTitle)
            }
        }
    }

    private var navigationLinkView: some View {
        NavigationLink(
            destination: ViewBuilder.buildMoviesDetailModule(id: presenter.selectedMovieID ?? 0),
            isActive: Binding(
                get: { presenter.selectedMovieID != nil },
                set: { if !$0 { presenter.selectedMovieID = nil } }
            )
        ) {
            EmptyView()
        }
    }

    private var gradientColor: LinearGradient {
        LinearGradient(colors: [Color("gradientTop"), Color("gradientBottom")], startPoint: .top, endPoint: .bottom)
    }

    // MARK: - Private Methods

    private func onAppear() {
        guard case .loading = presenter.state else { return }
        if swiftDataStoredMovies.isEmpty {
            presenter.requestMovies(context: context)
        } else {
            presenter.state = .data([])
        }
    }

    init(presenter: MoviesPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
}

#Preview {
    MoviesView(presenter: MoviesPresenter())
}
