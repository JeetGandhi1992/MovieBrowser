//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Rave on 12/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UpdateMovieResult {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var service = MovieServiceInteractor(page: 1)
        service.getMovies(vc: self, sortBy: MoviesSort.getMoviesByPopularity, page: 1)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(movies: Movie_Result, success: Bool) {
        if success {
            print(movies)
        }
    }

}

