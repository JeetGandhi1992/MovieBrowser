//
//  LoadingViewCell.swift
//  MovieBrowser
//
//  Created by Rave on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit 

class LoadingViewCell: UITableViewCell {

    @IBOutlet weak var Loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Loader.startAnimating()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
