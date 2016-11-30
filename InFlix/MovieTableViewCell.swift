//
//  MovieTableViewCell.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

protocol MovieCellDelegate: class {
    func movieCell(_ movieCell: MovieTableViewCell, didToogleButton toogle: Bool)
}

class MovieTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var movie: Movie? {
        didSet {
            titleLabel.text = movie!.title
            categoryLabel.text = movie!.category
            ratingLabel.text = "\(movie!.rating!)"
            yearLabel.text = String(describing: movie!.year!)
            let _ = NetflixRoulette.client().taskForGETImage(url: movie!.posterURL!){ (imageData, error) in
                if error == nil {
                    self.poster.image = UIImage(data: imageData!)
                } else {
                    self.poster.image = #imageLiteral(resourceName: "defaultPoster")
                }
            }
            heart.isHighlighted = movie!.isFavorite
        }
    }
    
    weak var delegate: MovieCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var heart: UIImageView!
    
    // MARK: Action
    
    @IBAction func toogleHeart(_ sender: HeartControl) {
        heart.isHighlighted = !heart.isHighlighted
        delegate?.movieCell(self, didToogleButton: heart.isHighlighted)
        movie?.isFavorite = heart.isHighlighted
    }

}
