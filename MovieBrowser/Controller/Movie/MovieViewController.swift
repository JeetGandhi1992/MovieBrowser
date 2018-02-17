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
        
    @IBOutlet weak var FilterBtn: UIButton!
    
    var PageCount = 1
    var displayGrid = true
    var isRefreshing = false
    var movies = [ Movie ]()
    var sortChoice = MoviesSort.getMoviesByPopularity
    
    var searchEnabled = false
    var query = ""
    var totalCount = 0
    var totalPages = 0
    
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
        service.getMovies(vc: self, sortBy: sortChoice, page: self.PageCount)
        
    }
    
    func getFilteredMovies() {
        
        self.isRefreshing = true
        var service = MovieDiscoverServiceInteractor(page: self.PageCount, query: self.query)
        service.getFilteredMovies(vc: self, page: self.PageCount)
        
    }

    func resetParameters() {
        
        self.PageCount = 1
        self.movies = [ Movie ]()
        self.totalPages = 0
        self.totalCount = 0
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
 
        if self.searchEnabled {
            self.searchEnabled = false
            self.FilterBtn.isHidden = false
        } else {
            self.searchEnabled = true
            self.FilterBtn.isHidden = true
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.resetParameters()
        
        self.MovieDisplayTable.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        self.MovieDisplayTable.scrollsToTop = true
        self.MovieDisplayTable.reloadData()
    }
    
    @IBAction func showAdvanceFilter() {
        
        self.performSegue(withIdentifier: "showAdvanceFilter", sender: nil)
    }
   
    func handleMovieResult(success: Bool, movies_result: Movie_Result) {

        if success {
            let updatedmovies = movies_result.results ?? [Movie]()
            
            if updatedmovies.count == 0 &&  self.movies.count == 0 {
                CRNotifications.showNotification(type: .info, title: "Sorry!", message: "No result found.", dismissDelay: 3)
            } else {
                self.movies = self.movies + updatedmovies
                self.totalCount = movies_result.total_results ?? 0
                self.totalPages = movies_result.total_pages ?? 0
                
                if self.totalCount != self.movies.count {
                    self.PageCount += 1
                }
            }
            self.MovieDisplayTable.reloadData()
            self.isRefreshing = false
        }
        else {
            CRNotifications.showNotification(type: .error, title: "Error!", message: "Unable to load data.", dismissDelay: 3)
        }
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchEnabled {
            return 44
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.searchEnabled {
            let searchCell = self.MovieDisplayTable.dequeueReusableCell(withIdentifier: "SearchBarViewCell") as! SearchBarViewCell
            return searchCell.contentView
            
        } else {
            return UIView()
        }
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

                switch (self.isRefreshing,self.searchEnabled) {
                    
                case (false,false):
                    if self.movies.count == self.totalCount && self.movies.count != 0 {
                        loadingCell.Loader.stopAnimating()
                    } else {
                        self.getMovies()
                        loadingCell.Loader.startAnimating()
                    }
                case (true,false):
                    loadingCell.Loader.startAnimating()
                case (false,true):
                    if self.movies.count == self.totalCount {
                        loadingCell.Loader.stopAnimating()
                    } else {
                        self.getFilteredMovies()
                        loadingCell.Loader.startAnimating()
                    }
                case (true,true):
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
            
            switch (self.isRefreshing,self.searchEnabled) {
                
            case (false,false):
                if self.movies.count == self.totalCount && self.movies.count != 0 {
                    loadingCell.Loader.stopAnimating()
                } else {
                    self.getMovies()
                    loadingCell.Loader.startAnimating()
                }
            case (true,false):
                loadingCell.Loader.startAnimating()
            case (false,true):
                if self.movies.count == self.totalCount {
                    loadingCell.Loader.stopAnimating()
                } else {
                    loadingCell.Loader.startAnimating()
                }
            case (true,true):
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
        if !self.searchEnabled {
            self.handleMovieResult(success: success, movies_result: movies_result)
        }
    }
}

extension MovieViewController: UpdateSearchMovieResult {
    
    func updateSearch(movies_result: Movie_Result, success: Bool) {
        if self.searchEnabled {
            self.handleMovieResult(success: success, movies_result: movies_result)
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
        self.resetParameters()
        self.getMovies()
    }
    
}

extension MovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count ?? 0 > 2 && !self.isRefreshing {
            self.query = searchBar.text!
            self.resetParameters()
            self.MovieDisplayTable.reloadData()
            self.getFilteredMovies()
        }
        searchBar.endEditing(true)
    }
    
}
