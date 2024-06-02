// SwiftDataMovies.swift
// Copyright © RoadMap. All rights reserved.

import SwiftData
import UIKit

@Model
final class SwiftDataMovie {
    let imageUrl: String
    let movieName: String
    let rating: Double
    let movieID: Int
    var image: Data?
    var id = UUID()

    init(imageUrl: String, movieName: String, rating: Double, id: Int, image: Data?) {
        self.imageUrl = imageUrl
        self.movieName = movieName
        self.rating = rating
        movieID = id
        self.image = image
    }
}
