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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    // MARK: Table View Cell
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
