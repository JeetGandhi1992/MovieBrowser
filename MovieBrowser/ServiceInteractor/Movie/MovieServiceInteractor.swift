//
//  MovieServiceInteractor.swift
//  MovieBrowser
//
//  Created by Rave on 13/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import Alamofire

protocol UpdateMovieResult {
    func update(movies_result: Movie_Result, success: Bool)
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
        
        var movies = Movie_Result()

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
            MovieServiceInteractor.sendResult(vc: vc, movies: movies, success: success)
        })
        
    }
    
    static func sendResult(vc: UIViewController, movies: Movie_Result, success: Bool ) {
        delegate = vc as? UpdateMovieResult
        delegate?.update(movies_result: movies, success: success)
    }

}
