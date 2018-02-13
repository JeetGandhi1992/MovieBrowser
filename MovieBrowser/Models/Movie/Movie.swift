//
//  Movie.swift
//  MovieBrowser
//
//  Created by Rave on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import ObjectMapper

struct Movie {

    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
    var id: Int?
    var original_title: String?
    var original_language: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Numeric?
    var vote_count: Int?
    var video: Bool?
    var vote_average: Numeric?
    
}

extension Movie: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.poster_path        <- map["poster_path"]
        self.adult      <- map["adult"]
        self.overview       <- map["overview"]
        self.release_date       <- map["release_date"]
        self.genre_ids      <- map["genre_ids"]
        self.id     <- map["id"]
        self.original_title     <- map["original_title"]
        self.original_language      <- map["original_language"]
        self.title      <- map["title"]
        self.backdrop_path      <- map["backdrop_path"]
        self.popularity     <- map["popularity"]
        self.vote_count     <- map["vote_count"]
        self.video      <- map["video"]
        self.vote_average       <- map["vote_average"]
        
    }
    
}
