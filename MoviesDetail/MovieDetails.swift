// MovieDetails.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieDetails.swift
//  CinemaStar
//
import UIKit

/// Детали фильма
struct MovieDetails: Identifiable {
    /// Название фильма
    let movieName: String
    /// Рейтинг фильма
    let movieRating: Double?
    /// URL изображения постера фильма
    let imageURL: String?
    /// Идентификатор фильма
    let movieID: Int
    /// Описание фильма
    let description: String?
    /// Год выпуска фильма
    let year: Int?
    /// Страна производства фильма
    let country: String?
    /// Тип контента фильма (например, фильм, сериал и т. д.)
    let genreFilm: String?
    /// Список актеров, участвующих в фильме
    var actors: [MovieActor] = []
    /// Язык фильма
    let language: String?
    /// Список похожих фильмов
    var similarMovies: [MoviesSimilars] = []
    /// Изображение постера фильма
    var image: UIImage?
    /// Уникальный идентификатор объекта
    var id = UUID()

    init(dto: MovieDTO) {
        movieName = dto.name
        movieRating = dto.rating?.kp
        imageURL = dto.poster.url
        movieID = dto.id
        description = dto.description
        year = dto.year
        country = dto.countries?.first?.name ?? ""
        genreFilm = {
            if dto.type == "movie" {
                return "Фильм"
            } else {
                return "Сериал"
            }
        }()
        language = dto.spokenLanguages?.first?.name
        dto.persons?.forEach { actor in
            if let actor = MovieActor(dto: actor) {
                actors.append(actor)
            }
        }
        dto.similarMovies?.forEach { similarMovies.append(MoviesSimilars(dto: $0)) }
    }

    init() {
        movieName = ""
        movieRating = nil
        imageURL = nil
        movieID = 1
        description = nil
        year = nil
        country = nil
        genreFilm = nil
        language = nil
    }
}
