//
//  MovieFilterViewController.swift
//  MovieBrowser
//
//  Created by Jeet on 15/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

class MovieFilterViewController: UIViewController {

    @IBOutlet weak var MovieFilterTable: UITableView!
    
    var sortChoice = MoviesSort.getMoviesByPopularity 
    var delegate: UpdateSortChoice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func DoneBtnClicked(sender: UIButton) {
        
        self.delegate?.update(sortChoice: self.sortChoice)
        self.navigationController?.popViewController(animated: true)
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

extension MovieFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let filterCell = self.MovieFilterTable.dequeueReusableCell(withIdentifier: "FilterViewCell", for: indexPath) as! FilterViewCell
        
        filterCell.delegate = self 
        filterCell.sortChoice = self.sortChoice
        
        return filterCell
        
    }
}

extension MovieFilterViewController: UpdateSortChoice {
    
    func update(sortChoice: MoviesSort) {
        self.sortChoice = sortChoice
    }
    
}
