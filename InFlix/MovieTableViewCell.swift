//
//  MovieTableViewCell.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var movie: Movie? {
        didSet {
            titleLabel.text = movie!.title
            categoryLabel.text = movie!.category
            ratingLabel.text = String(describing: movie!.rating!)
            yearLabel.text = String(describing: movie!.year!)
            poster.image = movie!.poster
            heartControl.isHighlighted = movie!.isFavorite
        }
    }
    
    var delegate: FavoriteCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var heartControl: HeartControl! {
        didSet {
            heartControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toogleHeart(_:))))
        }
    }
    
    // MARK: Table View Cell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toogleHeart(_ sender: UITapGestureRecognizer){
        let heart = sender.view as! UIImageView
        heart.isHighlighted = !heart.isHighlighted
        delegate?.favoriteCell(self, didToogleButton: heart.isHighlighted)
    }
    

}
