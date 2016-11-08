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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func addFavorite(_ movie: Movie){
        favoriteMovies += [movie]
        tableView.insertRows(at: [IndexPath(row: favoriteMovies.count - 1, section: 0)], with: .automatic)
    }
    
    func removeFavorite(_ movieToRemove: Movie){
        for (index,movie) in favoriteMovies.enumerated() {
            if movie === movieToRemove {
                favoriteMovies.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            favoriteMovies[indexPath.row].toogleFavorite()
            favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
