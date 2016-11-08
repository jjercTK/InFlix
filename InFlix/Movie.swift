//
//  Movie.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class Movie {
    
    // MARK: Properties
    
    var title: String?
    var rating: Double?
    var poster: UIImage?
    var category: String?
    var year: Int?
    var director: String?
    var length: Int? //minutes
    var isFavorite: Bool = false
    
    static var count = 1
    
    // MARK: Initializers
    
    init(title: String?, rating: Double?, poster: UIImage?, category: String?, year: Int?, director: String?, length: Int?) {
        self.title = title
        self.rating = rating
        self.poster = poster
        self.category = category
        self.year = year
        self.director = director
        self.length = length
    }
    
    init(){
        self.title = "Title \(Movie.count)"
        self.rating = 3
        self.poster = #imageLiteral(resourceName: "defaultPoster")
        self.category = "Category \(Movie.count)"
        self.year = 2016
        self.director = "Director \(Movie.count)"
        self.length = 120
        Movie.count += 1
    }
    
    func toogleFavorite(){
        isFavorite = !isFavorite
    }
    
}
