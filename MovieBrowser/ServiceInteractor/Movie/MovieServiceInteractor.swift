//
//  MovieServiceInteractor.swift
//  MovieBrowser
//
//  Created by Jeet on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Moya
import Alamofire

protocol UpdateMovieResult {
    func update(movies_result: MovieResult, success: Bool)
}

struct MovieServiceInteractor: TargetType {
    
    var page: Int = 1
    
    init(page: Int) {
        self.page = page
    }
    var baseURL: URL { return URL(string: Constants.BASE_URL)! }
    
    var path: String = ""
    
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
        
        return urlParameters
        
    }
    
}

extension MovieServiceInteractor {

    static var delegate : UpdateMovieResult?
    
    mutating func getMovies(vc: UIViewController, sortBy: MoviesSort, page: Int) {
        
        var movies = MovieResult()

        switch sortBy {
        case MoviesSort.getMoviesByPopularity:
                self.path = "3/movie/popular"
        case MoviesSort.getMoviesByTopRatings:
                self.path = "3/movie/top_rated"
        }
        
        let provider = MoyaProvider<MovieServiceInteractor>()
    
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
            MovieServiceInteractor.sendResult(vc: vc, movies: movies, success: success)
        })
        
    }
    
    static func sendResult(vc: UIViewController, movies: MovieResult, success: Bool ) {
        delegate = vc as? UpdateMovieResult
        delegate?.update(movies_result: movies, success: success)
    }

}
