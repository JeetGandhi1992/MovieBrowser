//
//  SearchBarViewCell.swift
//  MovieBrowser
//
//  Created by Rave on 17/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

class SearchBarViewCell: UITableViewCell {

    @IBOutlet weak var MovieSearchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

