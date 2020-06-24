//
//  ChosenMovieDetailsViewController.swift
//  The Movie DB
//
//  Created by Raz on 24/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class ChosenMovieDetailsViewController: UIViewController {
    
    let imageCache = NSCache<NSString, UIImage>()
    var highestPopularity = 260.0
    var movieId = 0
    public static let segue = "chosenMovieSegue"
    var chosenMovie: ChosenMovie?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        configureBackButton()
        configureTableView()
    }
    
    public func configurePage(){
        DataBase().parseChosenMovieFromJson(with: movieId) { (movie) in
            self.chosenMovie = movie
            
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.nameLabel.text = self.chosenMovie?.title
                
                if let url = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face\(self.chosenMovie?.posterPath ?? "")"){
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        self.moviePosterImageView.image = UIImage(data: imageData)
                    }
                }
                
                self.tableView.reloadData()
            }
            
            
        }
    }
    private func configureBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset.left = 15
        tableView.separatorInset.right = 15
    }
}


extension ChosenMovieDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsTableViewCell.identifier) as? MovieDetailsTableViewCell {
            if let chosenMovie = chosenMovie {
                cell.configureCell(chosenMovie: chosenMovie)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}


