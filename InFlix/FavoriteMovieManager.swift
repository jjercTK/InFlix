//
//  FavoriteMovieManager.swift
//  InFlix
//
//  Created by Juanjo on 11/22/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import Foundation

protocol FavoriteMovieManager: class {
    
    func addFavorite(_ movie: Movie)
    func removeFavorite(_ movieToRemove: Movie)
    
}

extension FavoriteMovieManager {
    
    func addFavoriteObservers(){
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKey.AddFavorite, object: nil, queue: nil) { [weak self] notification in
            if let movie = notification.object as? Movie {
                self?.addFavorite(movie)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKey.RemoveFavorite, object: nil, queue: nil) { [weak self] notification in
            if let movie = notification.object as? Movie {
                self?.removeFavorite(movie)
            }
        }
        
    }
    
    func removeFavoriteObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
}
