// ActorsDTO.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель с актерами фильма
struct PersonDTO: Codable {
    /// Имя актера
    let name: String?
    /// Ссылка на изображение актера
    let photo: String?
}
