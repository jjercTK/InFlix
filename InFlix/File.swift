//
//  File.swift
//  InFlix
//
//  Created by Juanjo on 11/28/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import Foundation

extension NetflixRoulette {
    
    func getMoviesForSearchString(_ search: String, completitionHandlerForMovies:@escaping (_ movies: [Movie]?, _ error: NSError) -> Void) -> URLSessionDataTask {
        
            
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [NetflixRoulette.ParameterKeys.Director: search]
        
        /* 2. Make the request */
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForMovies(nil, error)
            } else {
                
                if let results = results?[TMDBClient.JSONResponseKeys.MovieResults] as? [[String:AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    completionHandlerForMovies(movies, nil)
                } else {
                    completionHandlerForMovies(nil, NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
        
    }
}
