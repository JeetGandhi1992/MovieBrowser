//
//  MovieDiscoverServiceInteractor.swift
//  MovieBrowser
//
//  Created by Jeet on 15/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Moya
import Alamofire

protocol UpdateSearchMovieResult {
    func updateSearch(movies_result: MovieResult, success: Bool)
}

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
    
    static var delegate : UpdateSearchMovieResult?
    
    mutating func getFilteredMovies(vc: UIViewController, page: Int) {
        
        var movies = MovieResult()
        
        let provider = MoyaProvider<MovieDiscoverServiceInteractor>()

        provider.request(self, completion: { (result) in
            var success = true
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    movies = try decoder.decode(MovieResult.self, from: response.data)
                    success = true
                } catch let error {
                    print(error.localizedDescription)
                    success = false
                }
            case .failure(let error):
                print(error)
                success = false
            }
            MovieDiscoverServiceInteractor.sendResult(vc: vc, movies: movies, success: success)
        })
        
    }
    
    static func sendResult(vc: UIViewController, movies: MovieResult, success: Bool ) {
        delegate = vc as? UpdateSearchMovieResult
        delegate?.updateSearch(movies_result: movies, success: success)
    }
    
}
