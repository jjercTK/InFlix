//
//  FavoriteMovieTableViewCell.swift
//  InFlix
//
//  Created by Juanjo on 11/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class FavoriteMovieTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var movie: Movie? {
        didSet {
            poster.image = movie!.poster
            titleLabel.text = movie!.title
            yearLabel.text = String(describing: movie!.year!)
            categoryLabel.text = movie!.category
        }
    }
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: UITableViewCell

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
