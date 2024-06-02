// Movie.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Модель для  экрана с библиотекой фильмов
struct Movie {
    /// Индефикатор фильмма
    let id: Int
    /// Название изображения фильма
    let imageUrl: String?
    /// Название фильма
    let movieName: String?
    /// Рейтинг фильма
    let rating: Double?
    /// Картинка фильма
    var image: UIImage?

    init(dto: MovieDTO) {
        imageUrl = dto.poster.url
        movieName = dto.name
        rating = dto.rating?.kp
        id = dto.id
    }
}
