// MoviesSimilars.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Похожий фильм
struct MoviesSimilars: Identifiable, Codable {
    /// Постер
    let imageUrl: String?
    /// Название фильма
    let movieName: String?
    /// Рейтинг
    let rating: Double?
    /// Идентификатор
    let id: Int
    /// Картинка
    var image: Data?

    init(dto: MovieDTO) {
        imageUrl = dto.poster.url
        movieName = dto.name
        rating = dto.rating?.kp
        id = dto.id
    }
}
