//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Rave on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var MovieDetailTable: UITableView!
    
    var model: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = self.model?.original_title
        self.MovieDetailTable.rowHeight = UITableViewAutomaticDimension
        self.MovieDetailTable.estimatedRowHeight = 575
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieDetailViewController: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detailMovieCell = self.MovieDetailTable.dequeueReusableCell(withIdentifier: "MovieDetailViewCell", for: indexPath) as! MovieDetailViewCell
        
        detailMovieCell.model = self.model
        
        return detailMovieCell
        
    }
    
}
