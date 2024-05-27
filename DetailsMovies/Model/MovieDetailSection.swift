// MovieDetailSection.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieDetailSection.swift
//  CinemaStar
//
import Foundation

/// Типы ячеек для детального экрана
enum MovieDetailSection: CaseIterable {
    /// Постер и название фильма
    case info
    /// Описание фильма
    case description
    /// Кейс для секции с актерами
    case actors
    /// Кейс для секции с рекомендованными фильиами
    case similar
}
