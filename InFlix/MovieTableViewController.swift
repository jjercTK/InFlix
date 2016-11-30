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
    let searchController = UISearchController(searchResultsController: nil)
    var searchTask: URLSessionDataTask?
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadSampleMovies()
        addFavoriteObservers()
        setupSearchBar()
        setLoader()
        setupStyle()
    }
    
    deinit {
        removeFavoriteObservers()
    }
    
    // MARK: Methods
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = [
            NetflixRoulette.ParameterKeys.Title,
            NetflixRoulette.ParameterKeys.Director,
            NetflixRoulette.ParameterKeys.Actor
        ]
    }
    
//    private func loadSampleMovies(){
//        for _ in 0...10 {
//            movies += [Movie()]
//        }
//    }
    func setupStyle(){
        
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        
        if let task = searchTask {
            task.cancel()
        }
        
        movies = [Movie]()
        tableView?.reloadData()
        
        startLoading()
        searchTask = NetflixRoulette.client().getMovies(searchText, from: scope) { (movies) in
            DispatchQueue.main.async {
                self.stopLoading()
            }
            self.searchTask = nil
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.tableView!.reloadData()
                }
            }
        }
    }
    
    private func setLoader(){
        //setup loadingView
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = UIColor.gray
        loadingLabel.textAlignment = NSTextAlignment.center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        //setup spinner
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        //add views
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
        
        tableView.addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    func startLoading(){
        loadingView.isHidden = false
    }
    
    func stopLoading(){
        loadingView.isHidden = true
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: Storyboard.MovieTableViewCell, for: indexPath) as! MovieTableViewCell
        let movie: Movie
        movie = movies[indexPath.row]
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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

