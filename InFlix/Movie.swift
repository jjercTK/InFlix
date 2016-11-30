//
//  Movie.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import Foundation

class Movie: NSObject, NSCoding {
    
    // MARK: Properties
    
    var title: String?
    var rating: Double?
    var posterURL: URL?
    var category: String?
    var year: Int?
    var director: String?
    var length: String?
    var plot: String?
    var isFavorite: Bool = false
    
    static var count = 1
    
    // MARK: Types
    
    struct PropertyKey {
        static let titleKey = "title"
        static let ratingKey = "rating"
        static let directorKey = "director"
        static let yearKey = "year"
        static let categoryKey = "category"
        static let lengthKey = "length"
        static let posterURL = "posterURL"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        
        title = dictionary[NetflixRoulette.JSONResponseKeys.Title] as? String
        rating = Double(dictionary[NetflixRoulette.JSONResponseKeys.Rating] as! String)
        posterURL = URL(string: dictionary[NetflixRoulette.JSONResponseKeys.Poster] as! String)
        category = dictionary[NetflixRoulette.JSONResponseKeys.Category] as? String
        year = Int(dictionary[NetflixRoulette.JSONResponseKeys.Year] as! String)
        director = dictionary[NetflixRoulette.JSONResponseKeys.Director] as? String
        length = dictionary[NetflixRoulette.JSONResponseKeys.Length] as? String
        plot = dictionary[NetflixRoulette.JSONResponseKeys.Plot] as? String
        
        super.init()
    }
    
    init(title: String?, rating: Double?, posterURL: URL?, category: String?, year: Int?, director: String?, length: String?, plot: String?) {
        self.title = title
        self.rating = rating
        self.posterURL = posterURL
        self.category = category
        self.year = year
        self.director = director
        self.length = length
        self.plot = plot
        
        super.init()
    }
    
//    override init(){
//        self.title = "Title \(Movie.count)"
//        self.rating = 3
//        self.posterURL = nil
//        self.category = "Category \(Movie.count)"
//        self.year = 2016
//        self.director = "Director \(Movie.count)"
//        self.length = "120 min"
//        self.plot = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//        Movie.count += 1
//        
//        super.init()
//    }
    
    static func moviesFromResults(_ results: [[String:AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
    
    func toogleFavorite(){
        isFavorite = !isFavorite
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: PropertyKey.categoryKey)
        aCoder.encode(director, forKey: PropertyKey.directorKey)
        aCoder.encode(length, forKey: PropertyKey.lengthKey)
        aCoder.encode(posterURL, forKey: PropertyKey.posterURL)
        aCoder.encode(rating, forKey: PropertyKey.ratingKey)
        aCoder.encode(title, forKey: PropertyKey.titleKey)
        aCoder.encode(year, forKey: PropertyKey.yearKey)
    }
    
    init(_ category: String?, _ director: String?, _ length: String?, _ posterURL: URL?, _ rating: Double?, _ title: String?, _ year: Int?){
        self.category = category
        self.director = director
        self.length = length
        self.posterURL = posterURL
        self.rating = rating
        self.title = title
        self.year = year
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let category = aDecoder.decodeObject(forKey: PropertyKey.categoryKey) as? String
        let director = aDecoder.decodeObject(forKey: PropertyKey.directorKey) as? String
        let length = aDecoder.decodeObject(forKey: PropertyKey.lengthKey) as? String
        let posterURL = aDecoder.decodeObject(forKey: PropertyKey.posterURL) as? URL
        let rating = aDecoder.decodeObject(forKey: PropertyKey.ratingKey) as? Double
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as? String
        let year = aDecoder.decodeObject(forKey: PropertyKey.yearKey) as? Int
        
        self.init(category, director, length, posterURL, rating, title, year)
    }
    
}
