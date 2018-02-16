//
//  MovieViewCell.swift
//  MovieBrowser
//
//  Created by Jeet on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit
import Hero

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLbl: UILabel!
    
    @IBOutlet weak var movieImg: UIImageView!
    
    var model: Movie? {
        didSet {
            self.movieTitleLbl.text = self.model?.original_title
            
            let imgUrlStr = self.model?.poster_path ?? ""
            self.movieImg.sd_setImage(with: URL(string: Constants.BASE_IMG_URL + imgUrlStr), placeholderImage: #imageLiteral(resourceName: "movie_placeholder"), options: .progressiveDownload, completed: nil)
            
            self.movieImg.hero.id = self.model?.original_title
            self.movieImg.hero.modifiers = [.arc]
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
