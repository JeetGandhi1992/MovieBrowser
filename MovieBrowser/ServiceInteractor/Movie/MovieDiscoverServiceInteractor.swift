//
//  MovieDiscoverServiceInteractor.swift
//  MovieBrowser
//
//  Created by Jeet on 15/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import Alamofire

struct MovieDiscoverServiceInteractor: TargetType {
    
    var page: Int = 1
    var query: String = ""
    
    init(page: Int, query: String) {
        self.page = page
        self.query = query
    
    }
    var baseURL: URL { return URL(string: Constants.BASE_URL)! }
    
    var path: String = "3/search/movie"
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestCompositeData(bodyData: Data(), urlParameters: self.appendQueryString(page: self.page))
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var validate: Bool {
        return true
    }
    
    fileprivate func appendQueryString(page: Int) -> [String : Any] {
        
        var urlParameters = [String : Any]()
        
        urlParameters.updateValue(Constants.API_KEY, forKey: "api_key")
        urlParameters.updateValue("en-US", forKey: "language")
        urlParameters.updateValue(page, forKey: "page")
        urlParameters.updateValue(self.query, forKey: "query")
        
        return urlParameters
        
    }
    
}

extension MovieDiscoverServiceInteractor {
    
    static var delegate : UpdateMovieResult?
    
    mutating func getFilteredMovies(vc: UIViewController, page: Int) {
        
        var movies = Movie_Result()
        
        let provider = MoyaProvider<MovieDiscoverServiceInteractor>()
        
        provider.request(self, completion: { (result) in
            var success = true
            
            switch result {
            case .success(let response):
                do {
                    if let movieList = try response.mapJSON() as? [String :Any] {
                        movies = Mapper<Movie_Result>().map(JSON: movieList)!
                        success = true
                    }
                    else {
                        success = false
                    }
                } catch {
                    success = false
                }
            case .failure(let error):
                print(error)
            }
            MovieDiscoverServiceInteractor.sendResult(vc: vc, movies: movies, success: success)
        })
        
    }
    
    static func sendResult(vc: UIViewController, movies: Movie_Result, success: Bool ) {
        delegate = vc as? UpdateMovieResult
        delegate?.update(movies_result: movies, success: success)
    }
    
}
