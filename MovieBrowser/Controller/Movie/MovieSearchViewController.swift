//
//  MovieSearchViewController.swift
//  MovieBrowser
//
//  Created by Jeet on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import CRNotifications

class MovieSearchViewController: UIViewController {

    @IBOutlet weak var FilterMovieDisplayTable: UITableView!
    
    var PageCount = 1
    var displayGrid = true
    var isRefreshing = false
    var movies = [ Movie ]()
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Search Movies"
        self.FilterMovieDisplayTable.rowHeight = UITableViewAutomaticDimension
        self.FilterMovieDisplayTable.estimatedRowHeight = 260
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFilteredMovies() {
        
        self.isRefreshing = true
        var service = MovieDiscoverServiceInteractor(page: self.PageCount, query: self.query)
        service.getFilteredMovies(vc: self, page: self.PageCount)
        
    }
    
    @IBAction func toggleStyle(_ sender: UIButton) {
        
        if self.displayGrid {
            self.displayGrid = false
            sender.setTitle("", for: .normal)
        } else {
            self.displayGrid = true
            sender.setTitle("", for: .normal)
        }
        
        self.FilterMovieDisplayTable.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        
    }

}

extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.query.count > 2 {
            
            if self.displayGrid {
                return self.movies.count/2 + 1
            }
            else {
                return self.movies.count + 1
            }
            
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.movies.count > 0 {
            
            if (indexPath.row == self.movies.count) || (self.displayGrid && (indexPath.row == self.movies.count/2)) {
                
                let loadingCell = self.FilterMovieDisplayTable.dequeueReusableCell(withIdentifier: "LoadingViewCell", for: indexPath) as! LoadingViewCell
                
                if !isRefreshing {
                    self.getFilteredMovies()
                    loadingCell.Loader.startAnimating()
                }
                
                return loadingCell
                
            } else {
                
                if self.displayGrid {
                    
                    let movieGridCell = self.FilterMovieDisplayTable.dequeueReusableCell(withIdentifier: "MovieGridViewCell", for: indexPath) as! MovieGridViewCell
                    
                    movieGridCell.parentVc = self
                    var moviesList = [self.movies[2 * indexPath.row]]
                    
                    if self.movies.count >= 2 * indexPath.row {
                        
                        moviesList.append(self.movies[(2 * indexPath.row) + 1])
                    }
                    
                    movieGridCell.models = moviesList
                    
                    return movieGridCell
                    
                } else {
                    
                    let movieCell = self.FilterMovieDisplayTable.dequeueReusableCell(withIdentifier: "MovieViewCell", for: indexPath) as! MovieViewCell
                    
                    movieCell.model = self.movies[indexPath.row]
                    
                    return movieCell
                }
                
            }
            
        } else {
            
            let loadingCell = self.FilterMovieDisplayTable.dequeueReusableCell(withIdentifier: "LoadingViewCell", for: indexPath) as! LoadingViewCell
            
            if !isRefreshing {
                self.getFilteredMovies()
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

extension MovieSearchViewController: UpdateMovieResult {
    
    func update(movies_result: Movie_Result, success: Bool) {
        if success {
            let updatedmovies = movies_result.results ?? [Movie]()
            
            if updatedmovies.count == 0 &&  self.movies.count == 0 {
               CRNotifications.showNotification(type: .info, title: "Sorry!", message: "No result found.", dismissDelay: 3)
            } else {
                self.movies = self.movies + updatedmovies
                self.PageCount += 1
                self.FilterMovieDisplayTable.reloadData()
               
            }
            self.isRefreshing = false
        }
        else {
            CRNotifications.showNotification(type: .error, title: "Error!", message: "Enable to load data.", dismissDelay: 3)
        }
    }
}

extension MovieSearchViewController: SendSelectedMovie {
    
    func selected(movie: Movie) {
        self.performSegue(withIdentifier: "showMovieDetailForGrid", sender: movie)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 2 && !self.isRefreshing {
            self.query = searchText
            self.movies = [ Movie ]()
            self.PageCount = 1
            self.FilterMovieDisplayTable.reloadData()
            self.getFilteredMovies()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count ?? 0 > 2 && !self.isRefreshing {
            self.query = searchBar.text!
            self.movies = [ Movie ]()
            self.PageCount = 1
            self.FilterMovieDisplayTable.reloadData()
            self.getFilteredMovies()
        }
        else {
            self.query = ""
            self.movies = [ Movie ]()
            self.PageCount = 1
            self.FilterMovieDisplayTable.reloadData()
        }
        searchBar.endEditing(true)
    }
    
}
