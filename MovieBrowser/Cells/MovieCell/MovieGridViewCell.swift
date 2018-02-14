//
//  MovieGridViewCell.swift
//  MovieBrowser
//
//  Created by Rave on 14/02/18.
//  Copyright © 2018 Jeet Gandhi. All rights reserved.
//

import UIKit

protocol SendSelectedMovie {
    func selected(movie: Movie)
}

class MovieGridViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLbl1: UILabel!
    
    @IBOutlet weak var movieTitleLbl2: UILabel!
    
    @IBOutlet weak var movieImg1: UIImageView!
    
    @IBOutlet weak var movieImg2: UIImageView!
    
    var delegate : SendSelectedMovie?
    var parentVc : UIViewController?
    
    var models: [Movie]? {
        didSet {
            self.movieTitleLbl1.text = self.models?.first?.original_title
            
            let imgUrlStr1 = self.models?.first?.poster_path ?? ""
            self.movieImg1.sd_setImage(with: URL(string: Constants.BASE_IMG_URL + imgUrlStr1), placeholderImage: #imageLiteral(resourceName: "movie_placeholder"), options: .progressiveDownload, completed: nil)
            
            if (self.models?.count ?? 0) > 1 {
                
                self.movieTitleLbl1.isHidden = false
                self.movieImg2.isHidden = false
                
                self.movieTitleLbl2.text = self.models?.last?.original_title
                
                let imgUrlStr2 = self.models?.last?.poster_path ?? ""
                self.movieImg2.sd_setImage(with: URL(string: Constants.BASE_IMG_URL + imgUrlStr2), placeholderImage: #imageLiteral(resourceName: "movie_placeholder"), options: .progressiveDownload, completed: nil)
            }
            else {
                self.movieTitleLbl1.isHidden = true
                self.movieImg2.isHidden = true
            }
            
            let gestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(sendMovie))
            gestureRecognizerOne.numberOfTapsRequired = 1
            gestureRecognizerOne.numberOfTouchesRequired = 1
            gestureRecognizerOne.cancelsTouchesInView = true
            self.movieImg1.addGestureRecognizer(gestureRecognizerOne)
            
            let gestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(sendMovie))
            gestureRecognizerTwo.numberOfTapsRequired = 1
            gestureRecognizerTwo.numberOfTouchesRequired = 1
            gestureRecognizerTwo.cancelsTouchesInView = true
            self.movieImg2.addGestureRecognizer(gestureRecognizerTwo)

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sendMovie(_ sender: UITapGestureRecognizer) {
        
        self.delegate = parentVc as? SendSelectedMovie
        self.delegate?.selected(movie: self.models![(sender.view?.tag)!])
    }
    

}
