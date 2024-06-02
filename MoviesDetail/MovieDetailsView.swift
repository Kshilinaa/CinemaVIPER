// MovieDetailsView.swift
// Copyright © RoadMap. All rights reserved.

// swiftlint:disable all
//  MovieDetailsView.swift
//  CinemaStar
import SwiftData
import SwiftUI

// MARK: - Constants

enum Constants {
    static let empty = ""
    static let watch = "Смотреть"
    static let oops = "Упс!"
    static let inDevelopment = "Функционал в разработке :("
    static let ok = "Ок"
    static let backButtonImage = "chevron.backward"
    static let addToFavorites = "add to favorites"
    static let heart = "heart"
    static let heartFill = "heart.fill"
    static let error = "ERROR!!!"
    static let actorsCrew = "Актеры и сьемочная группа"
    static let language = "Язык"
    static let watchAlso = "Смотрите также"
    static let rating = "⭐️"
    static let bottonColor = "bottonColor"
    static let gradientTop = "gradientTop"
    static let gradientBottom = "gradientBottom"
    static let textColor = "textColor"
}

struct MovieDetailsView: View {
    // MARK: - Types

    /// Для сохранения данных
    @Environment(\.modelContext) private var context: ModelContext
    /// Запрос для получения детальной информации о фильме
    @Query var movieDetail: [SwiftDataMovieDetail]
    /// Свойство для закрытия вью
    @Environment(\.dismiss) var dismiss
    /// Состояние для отслеживания, нажата ли кнопка добавления в избранное
    @State var favoriteTap = false
    /// Состояние для отслеживания, нажата ли кнопка просмотра
    @State var butoonTapped = false
    /// Презентер для вью
    @StateObject var presenter: MovieDetailsPresenter
    /// Идентификатор фильма
    var id: Int?

    // MARK: - Body

    var body: some View {
        backgroundStackView(color: gradientColor) {
            ScrollView(showsIndicators: false) {
                switch presenter.state {
                case .loading:
                    Text(Constants.empty)
                case let .data(movieDetail):
                    VStack {
                        if movieDetail.movieName == Constants.empty {
                            makeMoviePosterView(
                                movie: movieDetail,
                                storedMovie: self.movieDetail.first(where: { $0.movieID == id })
                            )
                            Spacer()
                                .frame(height: 16)
                            watchButtonView
                            Spacer()
                                .frame(height: 16)
                            showMovieDetails(
                                movie: movieDetail,
                                storedMovie: self.movieDetail.first(where: { $0.movieID == id })
                            )
                            Spacer()
                                .frame(height: 16)
                            makeStarringView(
                                movie: movieDetail,
                                storedMovie: self.movieDetail.first(where: { $0.movieID == id })
                            )
                            Spacer()
                                .frame(height: 10)
                            makeRecommendedMoviesView(
                                movie: movieDetail,
                                storedMovie: self.movieDetail.first(where: { $0.movieID == id })
                            )
                        } else {
                            makeMoviePosterView(movie: movieDetail)
                            Spacer()
                                .frame(height: 16)
                            watchButtonView
                            Spacer()
                                .frame(height: 16)
                            showMovieDetails(movie: movieDetail)
                            Spacer()
                                .frame(height: 16)
                            makeStarringView(movie: movieDetail)
                            Spacer()
                                .frame(height: 10)
                            makeRecommendedMoviesView(movie: movieDetail)
                        }
                    }
                case .error:
                    Text(Constants.error)
                }
            }
            .toolbarBackground(gradientColor, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButtonView
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addToFavoritesButtonView
                }
            }
        }
        .onAppear {
            guard case .loading = presenter.state else { return }
            if movieDetail.first(where: { $0.movieID == self.id }) == nil {
                presenter.initializeMovieDetails(by: id ?? 0, context: context)
            } else {
                presenter.state = .data(MovieDetails())
                favoriteTap = fetchIsFavoriteState(id: id ?? 0)
            }
        }
    }

    // MARK: - Visual Components

    private var watchButtonView: some View {
        Button {
            butoonTapped.toggle()
        } label: {
            Text(Constants.watch)
                .frame(maxWidth: .infinity)
        }
        .foregroundColor(.white)
        .frame(width: 358, height: 48)
        .background(Color(Constants.bottonColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert(isPresented: $butoonTapped, content: {
            Alert(
                title: Text(Constants.oops),
                message: Text(Constants.inDevelopment),
                dismissButton: .default(Text(Constants.ok))
            )
        })
    }

    private var gradientColor: LinearGradient {
        LinearGradient(
            colors: [Color(Constants.gradientTop), Color(Constants.gradientBottom)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var backButtonView: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: Constants.backButtonImage)
        }
        .foregroundColor(.white)
    }

    private var addToFavoritesButtonView: some View {
        Button {
            favoriteTap.toggle()
            changeIsFavoriteState(favoriteTap, id: id ?? 0)
        } label: {
            favoriteTap
                ? Image("isFavorite")
                : Image("isNotFavorite")
        }
        .foregroundColor(.white)
    }

    init(presenter: MovieDetailsPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }

    // MARK: - Private Methods

    private func makeMoviePosterView(movie: MovieDetails, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        if storedMovie == nil {
            HStack {
                if let image = movie.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 170, height: 200)
                        .cornerRadius(8)
                } else {
                    ProgressView()
                        .frame(width: 170, height: 200)
                }
                VStack(alignment: .leading) {
                    Text(movie.movieName)
                        .font(.system(size: 18))
                        .frame(width: 150, alignment: .leading)
                        .lineLimit(5)
                        .bold()
                    Text("\(Constants.rating) \(String(format: "%.1f", movie.movieRating ?? 0.0))")
                }
                .foregroundColor(.white)
                .frame(width: 170, height: 70, alignment: .leading)
                Spacer()
            }
            .padding(.leading, 18)
        } else {
            HStack {
                if let image = UIImage(data: storedMovie?.image ?? Data()) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 170, height: 200)
                        .cornerRadius(8)
                } else {
                    ProgressView()
                        .frame(width: 170, height: 200)
                }
                VStack(alignment: .leading) {
                    Text(storedMovie?.movieName ?? Constants.empty)
                        .font(.system(size: 18))
                        .frame(width: 150, alignment: .leading)
                        .lineLimit(5)
                        .bold()
                    Text("\(Constants.rating) \(String(format: "%.1f", storedMovie?.movieRating ?? 0.0))")
                }
                .foregroundColor(.white)
                .frame(width: 170, height: 70, alignment: .leading)
                Spacer()
            }
            .padding(.leading, 18)
        }
    }

    private func showMovieDetails(movie: MovieDetails, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        if storedMovie == nil {
            VStack(alignment: .leading) {
                Text(movie.description ?? Constants.empty)
                    .font(.system(size: 14))
                    .lineLimit(5)
                    .foregroundColor(.white)
                Spacer()
                Text(
                    "\(String(movie.year ?? 0)) / \(movie.country ?? Constants.empty) / \(movie.genreFilm ?? Constants.empty)"
                )
                .font(.system(size: 14))
                .foregroundColor(Color(Constants.textColor))
            }
            .padding(.horizontal, 15)
        } else {
            VStack(alignment: .leading) {
                Text(storedMovie?.movieDescription ?? Constants.empty)
                    .font(.system(size: 14))
                    .lineLimit(5)
                    .foregroundColor(.white)
                Spacer()
                Text(
                    "\(String(storedMovie?.year ?? 0)) / \(storedMovie?.country ?? Constants.empty) / \(storedMovie?.contentType ?? Constants.empty)"
                )
                .font(.system(size: 14))
                .foregroundColor(Color(Constants.textColor))
            }
            .padding(.horizontal, 15)
        }
    }

    private func makeStarringView(movie: MovieDetails, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        if storedMovie == nil {
            VStack(alignment: .leading) {
                Text(Constants.actorsCrew)
                    .fontWeight(.medium)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(movie.actors, id: \.name) { actor in
                            VStack(spacing: 2) {
                                if let url = URL(string: actor.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 72)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 72)
                                    }
                                }
                                Text(actor.name)
                                    .font(.system(size: 8))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60, height: 24)
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height: 14)
                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.language)
                    Text(movie.language ?? Constants.empty)
                        .foregroundColor(Color(Constants.textColor))
                }
                .font(.system(size: 14))
            }
            .padding(.leading, 16)
            .foregroundColor(.white)
        } else {
            VStack(alignment: .leading) {
                Text(Constants.actorsCrew)
                    .fontWeight(.medium)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(storedMovie?.actors ?? [], id: \.name) { actor in
                            VStack(spacing: 2) {
                                if let url = URL(string: actor.imageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 72)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 72)
                                    }
                                }
                                Text(actor.name)
                                    .font(.system(size: 8))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 60, height: 24)
                            }
                        }
                    }
                }
                Spacer()
                    .frame(height: 14)
                VStack(alignment: .leading, spacing: 5) {
                    Text(Constants.language)
                    Text(storedMovie?.language ?? Constants.empty)
                        .foregroundColor(Color(Constants.textColor))
                }
                .font(.system(size: 14))
            }
            .padding(.leading, 16)
            .foregroundColor(.white)
        }
    }

    private func changeIsFavoriteState(_ isFavorite: Bool, id: Int) {
        print(id)
        presenter.toggleFavoriteState(isFavorite, id: id)
    }

    private func fetchIsFavoriteState(id: Int) -> Bool {
        presenter.retrieveFavoriteState(id: id)
    }

    private func makeRecommendedMoviesView(movie: MovieDetails, storedMovie: SwiftDataMovieDetail? = nil) -> some View {
        if storedMovie == nil {
            VStack(alignment: .leading) {
                Text(Constants.watchAlso)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                Spacer()
                    .frame(height: 12)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(movie.similarMovies, id: \.id) { movie in
                            VStack(alignment: .leading, spacing: 8) {
                                if let url = URL(string: movie.imageUrl ?? Constants.empty) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 170, height: 220)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 170, height: 200)
                                    }
                                }
                                Text(movie.movieName ?? Constants.empty)
                                    .font(.system(size: 16))
                                    .frame(width: 170, height: 18, alignment: .leading)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
            }
            .padding(.leading, 16)
            .foregroundColor(.white)
        } else {
            VStack(alignment: .leading) {
                Text(Constants.watchAlso)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                Spacer()
                    .frame(height: 12)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(storedMovie?.similarMovies ?? [], id: \.id) { movie in
                            VStack(alignment: .leading, spacing: 8) {
                                if let url = URL(string: movie.imageUrl ?? Constants.empty) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 170, height: 220)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 170, height: 200)
                                    }
                                }
                                Text(storedMovie?.movieName ?? Constants.empty)
                                    .font(.system(size: 16))
                                    .frame(width: 170, height: 18, alignment: .leading)
                            }
                            .padding(.trailing, 20)
                        }
                    }
                }
            }
            .padding(.leading, 16)
            .foregroundColor(.white)
        }
    }
}

#Preview {
    MovieDetailsView(presenter: MovieDetailsPresenter())
}

// swiftlint:enable all
