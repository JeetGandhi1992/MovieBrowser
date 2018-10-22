//
//  Movie_Result.swift
//  MovieBrowser
//
//  Created by Jeet on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

struct MovieResult: Codable {
    
    var page: Int?
    var results: [Movie]?
    var totalResults: Int?
    var totalPages: Int?
    
}


