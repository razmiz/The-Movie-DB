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
            movie?.results?.forEach({
                results.append($0)
            })
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDataBase()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: Functions
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset.left = 15
        tableView.separatorInset.right = 15
    }
    
    private func configureDataBase(){
        let count = 1...5
        for (index,_) in count.enumerated(){
            DataBase().parseMovieFromJson(with: index) { (movie) in
                self.movie = movie
            }
        }
    }
}

//MARK: Extensions
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier) as? MovieTableViewCell {
            let result = filteredResults[indexPath.row]
            cell.configureCell(result: result)
            activityIndicator.stopAnimating()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ChosenMovieViewController.segue, sender: filteredResults[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChosenMovieViewController.segue {
            if let dest = segue.destination as? ChosenMovieViewController {
                let result = sender as? Result
                dest.id = result?.id ?? 0
                dest.navigationItem.title = result?.title
                dest.configurePage()
            }
        }
    }
}

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
}

//Dismiss Keyboard by touching anywhere extension
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
