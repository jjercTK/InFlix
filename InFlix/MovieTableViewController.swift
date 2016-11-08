//
//  MovieTableViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController, FavoriteCellDelegate {
    
    // MARK: Properties
    
    var movies = [Movie]()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMovies()
    }
    
    // MARK: Methods
    
    func loadSampleMovies(){
        for _ in 0...10 {
            movies += [Movie()]
        }
        movies.first!.isFavorite = true
    }

    // MARK: UITableViewController

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MovieTableViewCell, for: indexPath) as! MovieTableViewCell
        let movie = movies[indexPath.row]
        
        cell.movie = movie
        cell.delegate = self

        return cell
    }
    
    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Storyboard.ShowMovieViewController?:
            let destination = segue.destination.content as! MovieViewController
            if let selectedMovieCell = sender as? MovieTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMovieCell)!
                let selectedMovie = movies[indexPath.row]
                destination.movie = selectedMovie
            }
        default:
            print("unknown segue")
        }
    }
    
    // MARK: FavoriteCellDelegate
    
    func favoriteCell(_ favoriteCell: MovieTableViewCell, didToogleButton toogle: Bool) {
        if toogle {
            NotificationCenter.default.post(Notification(name: NotificationCenterKey.AddFavorite, object: favoriteCell.movie, userInfo: nil))
        } else {
            NotificationCenter.default.post(Notification(name: NotificationCenterKey.RemoveFavorite, object: favoriteCell.movie, userInfo: nil))
        }
    }
    
}

