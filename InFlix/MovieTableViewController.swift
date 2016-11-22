//
//  MovieTableViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleMovies()
        addFavoriteObservers()
        
        // Setup search bar
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

    }
    
    deinit {
        removeFavoriteObservers()
    }
    
    // MARK: Methods
    
    func loadSampleMovies(){
        for _ in 0...10 {
            movies += [Movie()]
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredMovies = movies.filter({( movie : Movie) -> Bool in
            return movie.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowFilteredMovies() {
            return filteredMovies.count
        }
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: Storyboard.MovieTableViewCell, for: indexPath) as! MovieTableViewCell
        let movie: Movie
        if shouldShowFilteredMovies() {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        cell.movie = movie
        cell.delegate = self
        
        return cell
    }
    
    func shouldShowFilteredMovies() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
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

}

extension MovieTableViewController: MovieCellDelegate {
    
    // MARK: MovieCellDelegate
   
    func movieCell(_ movieCell: MovieTableViewCell, didToogleButton toogle: Bool) {
        if toogle {
            NotificationCenter.default.post(Notification(name: NotificationCenterKey.AddFavorite, object: movieCell.movie, userInfo: nil))
        } else {
            NotificationCenter.default.post(Notification(name: NotificationCenterKey.RemoveFavorite, object: movieCell.movie, userInfo: nil))
        }
    }
    
}

extension MovieTableViewController: UISearchBarDelegate {
    
    // MARK: UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
}

extension MovieTableViewController: UISearchResultsUpdating {
    
    // MARK: UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

extension MovieTableViewController: FavoriteMovieManager {
    
    // MARK: FavoriteMovieManager
    
    func addFavorite(_ movie: Movie) {}
    
    func removeFavorite(_ movieToRemove: Movie){
        for (index,movie) in movies.enumerated() {
            if movie === movieToRemove {
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                break
            }
        }
    }
    
}

