//
//  MovieDetailViewCell.swift
//  MovieBrowser
//
//  Created by Jeet on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Hero

class MovieDetailViewCell: UITableViewCell {

    
    @IBOutlet weak var MoviePosterImg: UIImageView!
    
    @IBOutlet weak var VoteAverageLbl: UILabel!
    
    @IBOutlet weak var ReleaseDateLbl: UILabel!
    
    @IBOutlet weak var OverViewLbl: UILabel!
    
    var model: Movie? {
        didSet {
            
            self.VoteAverageLbl.text = self.model?.vote_average?.stringValue
            self.ReleaseDateLbl.text = self.model?.release_date
            self.OverViewLbl.text = self.model?.overview
            
            self.MoviePosterImg.hero.id = self.model?.original_title
            self.MoviePosterImg.hero.modifiers = [.arc]
            
            let imgUrlStr = self.model?.poster_path ?? ""
            self.MoviePosterImg.sd_setImage(with: URL(string: Constants.BASE_IMG_URL + imgUrlStr), placeholderImage: #imageLiteral(resourceName: "movie_placeholder"), options: .progressiveDownload, completed: nil)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
