// MoviesCollectionView.swift
// Copyright © RoadMap. All rights reserved.

import SwiftUI

/// Вью с фильмами
struct MoviesCollectionView: View {
    /// Объявление окружения с презентером
    @EnvironmentObject var presenter: MoviesPresenter

    // MARK: - Types

    /// Определение столбцов для сетки
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    /// Список фильмов
    var movies: [Movie] = []
    /// Список фильмов SwiftData
    var swiftDataMovies: [SwiftDataMovie] = []

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            textView
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    if movies.isEmpty {
                        swiftDataMoviesView
                    } else {
                        moviesView
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Visual Components

    private var textView: some View {
        VStack {
            Text("Смотри исторические\nфильмы на ")
                +
                Text("CINEMA STAR")
                .fontWeight(.heavy)
        }
    }

    private var swiftDataMoviesView: some View {
        ForEach(swiftDataMovies, id: \.id) { movie in
            movieView(movie: movie)
                .onTapGesture {
                    presenter.showMovieDetail(with: movie.movieID)
                    print(movie.id)
                }
        }
    }

    private var moviesView: some View {
        ForEach(movies, id: \.id) { movie in
            movieView(movie: movie)
                .onTapGesture {
                    presenter.showMovieDetail(with: movie.id)
                }
        }
    }

    private func movieView(movie: Movie) -> some View {
        VStack {
            if let image = movie.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 170, height: 220)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 170, height: 220)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.movieName ?? "")
                Text("⭐️ \(String(format: "%.1f", movie.rating ?? 0.0))")
            }
            .frame(width: 170, height: 40, alignment: .leading)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }

    private func movieView(movie: SwiftDataMovie) -> some View {
        VStack {
            if let imageData = movie.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 170, height: 220)
                    .cornerRadius(8)
            } else {
                ProgressView()
                    .frame(width: 170, height: 220)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.movieName)
                Text("⭐️ \(String(format: "%.1f", movie.rating))")
            }
            .frame(width: 170, height: 40, alignment: .leading)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
}
