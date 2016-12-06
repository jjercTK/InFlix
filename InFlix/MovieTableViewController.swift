//
//  MovieTableViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MovieTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var movies = [Movie]()
    var searchController: CustomSearchController!
    var searchTask: URLSessionDataTask?
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var displaySearchBar = false
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadSampleMovies()
        addFavoriteObservers()
        configureCustomSearchController()
        setLoader()
        emptyDataSet()
    }
    
    deinit {
        removeFavoriteObservers()
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        if displaySearchBar {
            tableView.tableHeaderView = searchController.customSearchBar
        } else {
            tableView.tableHeaderView = nil
            searchController.isActive = false
        }
        displaySearchBar = !displaySearchBar
    }
    
    
    // MARK: Methods
    
    func configureCustomSearchController() {
        
        let searchBarFrame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 50.0)
        searchController = CustomSearchController(searchResultsController: self, searchBarFrame: searchBarFrame, searchBarFont: FontHelper.text, searchBarTextColor: ColorHelper.white, searchBarTintColor: ColorHelper.black)
        
        searchController.customSearchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.customSearchBar
        searchController.customSearchBar.delegate = self
        definesPresentationContext = true
        searchController.customSearchBar.scopeButtonTitles = [
            NetflixRoulette.ParameterKeys.Title,
            NetflixRoulette.ParameterKeys.Director,
            NetflixRoulette.ParameterKeys.Actor
        ]
        searchController.customSearchBar.isHidden = false
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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

extension MovieTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSet(){
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome to InFlix!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search a movie for your next\n Netflix n' chill session ;)"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}

