//
//  Constants.swift
//  MovieBrowser
//
//  Created by Jeet on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

class Constants {

    static let sharedInstance = Constants()
    
    static let API_KEY = Constants.sharedInstance.getAPIBaseURL(key: "APIKEY")
    static let BASE_URL = Constants.sharedInstance.getAPIBaseURL(key: "APIURLEndpoint")
    static let BASE_IMG_URL = Constants.sharedInstance.getAPIBaseURL(key: "APIIMGURLENDPOINT")
    
    fileprivate func getAPIBaseURL(key: String) -> String {
        guard let urlStr = (Bundle.main.object(forInfoDictionaryKey: key) as? String)?.trimmingCharacters(in: .whitespaces) else {
            return ""
        }
        return urlStr
    }
    
}
