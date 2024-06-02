// CinemaStarApp.swift
// Copyright © RoadMap. All rights reserved.

import SwiftData
import SwiftUI

@main
struct CinemaStarApp: App {
    var body: some Scene {
        WindowGroup {
            ViewBuilder.buildMoviesModule()
                .modelContainer(for: [SwiftDataMovie.self, SwiftDataMovieDetail.self])
        }
    }
}
