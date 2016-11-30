//
//  FavoriteTableViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/7/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var favoriteMovies = [Movie]()
    
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addFavoriteObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movies = loadMeals() {
            favoriteMovies = movies
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    deinit {
        removeFavoriteObservers()
    }
    
    // MARK: Methods
    
    func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoriteMovies, toFile: Movie.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save movies...")
        }
    }
    
    func loadMeals() -> [Movie]? {
        let movies = NSKeyedUnarchiver.unarchiveObject(withFile: Movie.ArchiveURL.path) as? [Movie]
        return movies
        
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteMovie = favoriteMovies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.FavoriteMovieTableViewCell, for: indexPath) as! FavoriteMovieTableViewCell

       cell.movie = favoriteMovie

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteMovie = favoriteMovies[indexPath.row]
            favoriteMovie.toogleFavorite()
            favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(Notification(name: NotificationCenterKey.RemoveFavorite, object: favoriteMovie, userInfo: nil))
        }    
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Storyboard.ShowMovieViewController?:
            let destination = segue.destination.content as! MovieViewController
            if let selectedMovieCell = sender as? FavoriteMovieTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMovieCell)!
                let selectedMovie = favoriteMovies[indexPath.row]
                destination.movie = selectedMovie
            }
        default:
            print("unknown segue")
        }
    }

}

extension FavoriteTableViewController: FavoriteMovieManager {
    
    // MARK: FavoriteMovieManager
    
    func addFavorite(_ movie: Movie){
        favoriteMovies += [movie]
        saveMovies()
        tableView.insertRows(at: [IndexPath(row: favoriteMovies.count - 1, section: 0)], with: .automatic)
    }
    
    func removeFavorite(_ movieToRemove: Movie){
        for (index,movie) in favoriteMovies.enumerated() {
            if movie === movieToRemove {
                favoriteMovies.remove(at: index)
                saveMovies()
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                break
            }
        }
    }
    
}
