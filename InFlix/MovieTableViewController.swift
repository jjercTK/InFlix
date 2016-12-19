//
//  MovieTableViewController.swift
//  InFlix
//
//  Created by Juanjo on 11/4/16.
//  Copyright © 2016 Tektonlabs. All rights reserved.
//

import UIKit
//import DZNEmptyDataSet

class MovieTableViewController: UIViewController {
    
    // MARK: Properties
    
    var movies = [Movie]()
    var searchController: CustomSearchController!
    var searchTask: URLSessionDataTask?
    
    var loadingView = LoadingView()
    var emptyView = EmptyView()
    var errorView = ErrorView()
    var state: ViewControllerState = .Empty
    
    var displaySearchBar = false
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadSampleMovies()
        tableView.delegate = self
        tableView.dataSource = self
        addFavoriteObservers()
        configureCustomSearchController()
        changeState(to: state)
//        setLoader()
//        emptyDataSet()
        
    }
    
    deinit {
        removeFavoriteObservers()
    }
    
    // MARK: Actions
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        if displaySearchBar {
            showSearchBar()
        } else {
            hideSearchBar()
        }
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
            NetflixRoulette.ParameterKeys.Title.capitalizingFirstLetter(),
            NetflixRoulette.ParameterKeys.Director.capitalizingFirstLetter(),
            NetflixRoulette.ParameterKeys.Actor.capitalizingFirstLetter()
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
        searchTask = NetflixRoulette.client().getMovies(searchText, from: scope) { (movies, error) in
                        self.searchTask = nil
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.tableView!.reloadData()
                    self.endLoading(withError: error)
                }
            } else {
                DispatchQueue.main.async {
                    self.endLoading(withError: error)
                }
            }
        }
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
        hideSearchBar()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func hideSearchBar(){
        tableView.tableHeaderView = nil
        searchController.isActive = false
        displaySearchBar = true
    }
    
    func showSearchBar(){
        tableView.tableHeaderView = searchController.customSearchBar
        displaySearchBar = false
        //tableView.setContentOffset(CGPoint.zero, animated: true)
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

//extension MovieTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    
//    func emptyDataSet(){
//        tableView.emptyDataSetSource = self
//        tableView.emptyDataSetDelegate = self
//        tableView.tableFooterView = UIView()
//    }
//    
//    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let str = "Welcome to InFlix!"
//        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
//    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let str = "Search a movie for your next\n Netflix n' Chill session ;)"
//        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
//    
//}

extension MovieTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: Storyboard.MovieTableViewCell, for: indexPath) as! MovieTableViewCell
        let movie: Movie
        movie = movies[indexPath.row]
        cell.movie = movie
        cell.delegate = self
        
        return cell
    }
}

extension MovieTableViewController: StatefulViewController {
    
    internal var currentState: ViewControllerState {
        get {
            return state
        }
        set {
            state = newValue
        }
    }

    
    weak internal var loadingStateView: UIView? {
        get {
            return loadingView
        }
        set {
            loadingView = newValue as! LoadingView
        }
    }
    
    weak internal var emptyStateView: UIView? {
        get {
            return emptyView
        }
        set {
            emptyView = newValue as! EmptyView
        }
    }
    
    weak internal var errorStateView: UIView? {
        get {
            return errorView
        }
        set {
            errorView = newValue as! ErrorView
        }
    }
    
    func hasContent() -> Bool {
        return !movies.isEmpty
    }

    
    func placeholderViewConstraints() -> [NSLayoutConstraint] {
        if let currentView = currentView {
            let leadingConstraint = NSLayoutConstraint(item: currentView, attribute: .leading, relatedBy: .equal, toItem: tableView, attribute: .leading, multiplier: 1.0, constant: 0.0)
            let trailingConstraint = NSLayoutConstraint(item: currentView, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            let bottomConstraint = NSLayoutConstraint(item: currentView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
            let topConstraint = NSLayoutConstraint(item: currentView, attribute: .top, relatedBy: .equal, toItem: searchController.customSearchBar, attribute: .bottom, multiplier: 1.0, constant: 63)
        
            return [leadingConstraint, trailingConstraint,bottomConstraint, topConstraint]
        }
        return []
    }

}
