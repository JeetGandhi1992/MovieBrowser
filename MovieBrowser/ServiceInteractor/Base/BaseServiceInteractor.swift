//
//  BaseServiceInteractor.swift
//  ProjectBase
//
//  Created by Rave on 19/01/18.
//  Copyright © 2018 Rave. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

struct BaseServiceInteractor: TargetType {
    
    var baseURL: URL { return URL(string: getAPIBaseURL())! }
    
    var path: String = ""
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.prettyPrinted
    }
    
    fileprivate func getAPIBaseURL() -> String {
        var urlStr = String(describing: Bundle.main.object(forInfoDictionaryKey: "APIURLEndpoint")!)
        urlStr = urlStr.trimmingCharacters(in: .whitespaces)
        return urlStr
    }

}
