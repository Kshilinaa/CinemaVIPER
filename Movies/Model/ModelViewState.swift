// ModelViewState.swift
// Copyright © RoadMap. All rights reserved.

//
//  ModelViewState.swift
//  CinemaStar
import Foundation

/// Состояние  данных на экране фильмов
public enum ModelViewState<Model> {
    /// Данные загружаются
    case loading
    /// Есть данные
    case data(_ data: Model)
    /// Нет данных
    case noData
    /// Ошибка
    case error
}
