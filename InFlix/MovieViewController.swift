//
//  MovieViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var directoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    var movie: Movie?
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movie {
            poster.image = movie.poster
            titleLabel.text = movie.title
            categoryLabel.text = movie.category
            directoryLabel.text = movie.director
            ratingLabel.text = String(movie.rating!)
            yearLabel.text = String(movie.year!)
            lengthLabel.text = String(movie.length!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
