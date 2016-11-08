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
            heart.isHighlighted = movie!.isFavorite
        }
    }
    
    var delegate: FavoriteCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var heart: UIImageView!
    
    // MARK: Action
    
    @IBAction func toogleHeart(_ sender: HeartControl) {
        heart.isHighlighted = !heart.isHighlighted
        delegate?.favoriteCell(self, didToogleButton: heart.isHighlighted)
        movie?.isFavorite = heart.isHighlighted
    }

}
