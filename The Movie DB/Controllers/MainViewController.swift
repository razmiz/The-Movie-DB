//
//  MainViewController.swift
//  The Movie DB
//
//  Created by Raz on 19/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: Properties
    var pageNumber = 1
    var lastPage = false
    var filteredResults = [Result]()
    var results = [Result](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.filteredResults = self.results
            }
        }
    }
    var movie: Movie? {
        didSet{
            lastPage = checkIfLastPage(movie: movie!)
            movie?.results?.forEach({
                results.append($0)
                results.sort { (result1, result2) -> Bool in
                    result1.popularity > result2.popularity
                }
            })
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        loadDataBase()
        hideKeyboardWhenTappedAround()
        
    }
    
    //MARK: Functions
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset.left = 15
        tableView.separatorInset.right = 15
    }
    
    private func loadDataBase(){
//        print("pageNumber = \(pageNumber)")
        guard pageNumber < 15 else { return }
//        guard !lastPage else { return }
        DataBase().parseMovieFromJson(with: pageNumber) { (movie) in
            self.movie = movie
        }
    }
    
    private func checkIfLastPage(movie: Movie) -> Bool{
        return movie.results?.count ?? 0 < 20
    }
}

//MARK: Extensions - TableView
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell {
            if indexPath.row == self.filteredResults.count - 1 {
                pageNumber += 1
                loadDataBase()
            }
            let result = filteredResults[indexPath.row]
            cell.configureCell(result: result)
            activityIndicator.stopAnimating()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ChosenMovieDetailsViewController.segue, sender: filteredResults[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChosenMovieDetailsViewController.segue {
            if let dest = segue.destination as? ChosenMovieDetailsViewController {
                let result = sender as? Result
                dest.movieId = result?.id ?? 0
                dest.navigationItem.title = result?.title
                dest.configurePage()
            }
        }
    }
    
    
}

//MARK: Extension - SearchBar
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if !text.isEmpty {
            filteredResults = results.filter({ $0.title.lowercased().contains(text.lowercased())})
        } else{
            filteredResults = results
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
