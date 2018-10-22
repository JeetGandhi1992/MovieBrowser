//
//  Movie.swift
//  MovieBrowser
//
//  Created by Jeet on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

struct Movie: Codable {

    var posterPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: String?
    var genreIds: [Int]?
    var id: Int?
    var originalTitle: String?
    var originalLanguage: String?
    var title: String?
    var backdropPath: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Double?
    
}


enum MoviesSort {
    
    case getMoviesByPopularity
    case getMoviesByTopRatings
    
}

