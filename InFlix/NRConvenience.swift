//
//  NRConvenience.swift
//  InFlix
//
//  Created by Juanjo on 11/28/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import Foundation

extension NetflixRoulette {
    
    func getMovies(_ search: String?, from scope: String, completionHandlerForMovies: @escaping (_ results: [Movie]?) -> Void) -> URLSessionDataTask?{
        
        /* 1. Specify parameters */
        let parameters = [scope: search]
        
        /* 2. Make the request */
        let task = taskForGETMethod(nil, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if error != nil {
                completionHandlerForMovies(nil)
            } else {
                
                if let results = results as? [[String:AnyObject]] {
                    let movies = Movie.moviesFromResults(results)
                    completionHandlerForMovies(movies)
                } else if let result = results as? [String:AnyObject]{
                    let movie = Movie(dictionary: result)
                    completionHandlerForMovies([movie])
                } else {
                    completionHandlerForMovies(nil)
                }
            }
        }
        
        return task
    }
    
    
}

