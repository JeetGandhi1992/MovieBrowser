//
//  MovieViewController.swift
//  MovieBrowser
//
//  Created by Jeet on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import CRNotifications

class MovieViewController: UIViewController {

    
    @IBOutlet weak var MovieDisplayTable: UITableView!
        
    var PageCount = 1
    var displayGrid = true
    var isRefreshing = false
    var movies = [ Movie ]()
    var sortChoice = MoviesSort.getMoviesByPopularity
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.title = "Movies"
        self.MovieDisplayTable.rowHeight = UITableViewAutomaticDimension
        self.MovieDisplayTable.estimatedRowHeight = 260
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMovies() {
        
        self.isRefreshing = true
        var service = MovieServiceInteractor(page: PageCount)
        service.getMovies(vc: self, sortBy: sortChoice, page: PageCount)
        
    }

    @IBAction func toggleStyle(_ sender: UIButton) {
        
        if self.displayGrid {
            self.displayGrid = false
            sender.setTitle("", for: .normal)
        } else {
            self.displayGrid = true
            sender.setTitle("", for: .normal)
        }
        
        self.MovieDisplayTable.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    @IBAction func showDetailSearch() {
        
        self.performSegue(withIdentifier: "ShowDiscovery", sender: nil)
    }
    
    @IBAction func showAdvanceFilter() {
        
        self.performSegue(withIdentifier: "showAdvanceFilter", sender: nil)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetail" {
            if let detailMovieVc = segue.destination as? MovieDetailViewController {
                detailMovieVc.model = self.movies[sender as! Int]
                detailMovieVc.title = self.movies[sender as! Int].original_title
            }
        }
        else if segue.identifier == "showMovieDetailForGrid" {
            if let detailMovieVc = segue.destination as? MovieDetailViewController {
                detailMovieVc.model = sender as? Movie
                detailMovieVc.title = (sender as? Movie)?.original_title
            }
        }
        else if segue.identifier == "showAdvanceFilter" {
            if let filterVc = segue.destination as? MovieFilterViewController {
                filterVc.delegate = self
                filterVc.sortChoice = self.sortChoice
            }
        }
        
    }


}

extension MovieViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.displayGrid {
            return self.movies.count/2 + 1
        }
        else {
            return self.movies.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.movies.count > 0 {
            
            if (indexPath.row == self.movies.count) || (self.displayGrid && (indexPath.row == self.movies.count/2)) {
                
                let loadingCell = self.MovieDisplayTable.dequeueReusableCell(withIdentifier: "LoadingViewCell", for: indexPath) as! LoadingViewCell
                
                if !isRefreshing {
                    self.getMovies()
                    loadingCell.Loader.startAnimating()
                }
                
                return loadingCell
                
            } else {
                
                if self.displayGrid {
                    
                    let movieGridCell = self.MovieDisplayTable.dequeueReusableCell(withIdentifier: "MovieGridViewCell", for: indexPath) as! MovieGridViewCell
                    
                    movieGridCell.parentVc = self
                    var moviesList = [self.movies[2 * indexPath.row]]
                    
                    if self.movies.count >= 2 * indexPath.row {
                        
                        moviesList.append(self.movies[(2 * indexPath.row) + 1])
                    }
                    
                    movieGridCell.models = moviesList
                    
                    return movieGridCell
                    
                } else {
                    
                    let movieCell = self.MovieDisplayTable.dequeueReusableCell(withIdentifier: "MovieViewCell", for: indexPath) as! MovieViewCell
                    
                    movieCell.model = self.movies[indexPath.row]
                    
                    return movieCell
                }
                
            }
            
        } else {
            
            let loadingCell = self.MovieDisplayTable.dequeueReusableCell(withIdentifier: "LoadingViewCell", for: indexPath) as! LoadingViewCell
            
            if !isRefreshing {
                self.getMovies()
                loadingCell.Loader.startAnimating()
            }
            
            return loadingCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !self.displayGrid {
            
            self.performSegue(withIdentifier: "showMovieDetail", sender: indexPath.row)
            
        } else {
            
        }
    }
    
}

extension MovieViewController: UpdateMovieResult {
    
    func update(movies_result: Movie_Result, success: Bool) {
        if success {
            let updatedmovies = movies_result.results ?? [Movie]()
            self.movies = self.movies + updatedmovies
            PageCount += 1
            self.MovieDisplayTable.reloadData()
            self.isRefreshing = false
        }
        else {
            CRNotifications.showNotification(type: .error, title: "Error!", message: "Enable to load data.", dismissDelay: 3)
        }
    }
}

extension MovieViewController: SendSelectedMovie {
    
    func selected(movie: Movie) {
        self.performSegue(withIdentifier: "showMovieDetailForGrid", sender: movie)
    }
}

extension MovieViewController: UpdateSortChoice {
    
    func update(sortChoice: MoviesSort) {
        self.sortChoice = sortChoice
        self.movies = [ Movie ]()
        self.PageCount = 1
        self.getMovies()
    }
    
}
