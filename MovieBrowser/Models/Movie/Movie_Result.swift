//
//  Movie_Result.swift
//  MovieBrowser
//
//  Created by Rave on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import ObjectMapper

struct Movie_Result {
    
    var page: Int?
    var result: [Movie]?
    var total_results: Int?
    var total_pages: Int?
    
}

extension Movie_Result: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.page       <- map["page"]
        self.result     <- map["result"]
        self.total_results      <- map["total_results"]
        self.total_pages        <- map["total_pages"]
        
    }
    
}
