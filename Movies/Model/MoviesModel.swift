// MoviesModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель для  экрана с библиотекой фильмов
struct Movie {
    /// Индефикатор фильмма
    let id: Int
    /// Название изображения фильма
    let imageUrl: URL?
    /// Название фильма
    let movieName: String?
    /// Рейтинг фильма
    let rating: Double?

    init(dto: MovieDTO) {
        id = dto.id
        imageUrl = URL(string: dto.poster.url)
        movieName = dto.name
        rating = Double(String(format: "%.1f", dto.rating?.kp ?? 1.0)) ?? 0
    }
}
