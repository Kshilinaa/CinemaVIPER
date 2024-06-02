// MovieActor.swift
// Copyright © RoadMap. All rights reserved.

//  MovieActor.swift
//  CinemaStar
import Foundation

/// Информация об актере
struct MovieActor: Identifiable, Codable {
    /// Идентификатор
    var id = UUID()
    /// Имя актера
    let name: String
    /// Ссылка на изображение актера
    let imageURL: String

    init?(dto: PersonDTO) {
        guard let name = dto.name else { return nil }
        self.name = name
        imageURL = dto.photo ?? ""
    }
}
