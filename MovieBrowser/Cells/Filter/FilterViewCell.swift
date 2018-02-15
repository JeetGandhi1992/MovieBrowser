//
//  FilterViewCell.swift
//  MovieBrowser
//
//  Created by Jeet on 15/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

protocol UpdateSortChoice {
    func update(sortChoice: MoviesSort)
}

class FilterViewCell: UITableViewCell {

    var delegate: UpdateSortChoice?
    
    var sortChoice = MoviesSort.getMoviesByPopularity {
        didSet {
            switch sortChoice {
            case .getMoviesByPopularity:
                self.PopularityBtn.setTitle("", for: .normal)
                self.TopRatedBtn.setTitle("", for: .normal)
            case .getMoviesByTopRatings:
                self.PopularityBtn.setTitle("", for: .normal)
                self.TopRatedBtn.setTitle("", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var PopularityBtn: UIButton!
    @IBOutlet weak var TopRatedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        switch sortChoice {
        case .getMoviesByPopularity:
            self.PopularityBtn.setTitle("", for: .normal)
            self.TopRatedBtn.setTitle("", for: .normal)
        case .getMoviesByTopRatings:
            self.PopularityBtn.setTitle("", for: .normal)
            self.TopRatedBtn.setTitle("", for: .normal)
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ToggleSort(sender: UIButton) {
        
        if sender.tag == 0 {
            self.PopularityBtn.setTitle("", for: .normal)
            self.TopRatedBtn.setTitle("", for: .normal)
            self.sortChoice = MoviesSort.getMoviesByPopularity
        } else {
            self.PopularityBtn.setTitle("", for: .normal)
            self.TopRatedBtn.setTitle("", for: .normal)
            self.sortChoice = MoviesSort.getMoviesByTopRatings
        }
        self.delegate?.update(sortChoice: self.sortChoice)
        
    }

}

