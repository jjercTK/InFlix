//
//  NRConfig.swift
//  InFlix
//
//  Created by Juanjo on 11/28/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

extension NetflixRoulette {
    
    // MARK: URLs
    static let ApiScheme = "http"
    static let ApiHost = "netflixroulette.net"
    static let ApiPath = "/api/api.php"
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Director = "director"
        static let Title = "title"
        static let Actor = "actor"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Title = "show_title"
        static let Rating = "rating"
        static let Poster = "poster"
        static let Category = "category"
        static let Year = "release_year"
        static let Director = "director"
        static let Length = "runtime"
        static let Actors = "show_cast"
        static let Plot = "summary"
        
    }

}
