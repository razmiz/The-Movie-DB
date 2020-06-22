//
//  ChosenMovieViewController.swift
//  The Movie DB
//
//  Created by Raz on 20/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class ChosenMovieViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var productionCompanyImageView: UIImageView!
    @IBOutlet weak var productionCompanyNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    public static let segue = "chosenMovieSegue"
    var id = 0
    var chosenMovie: ChosenMovie?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    //MARK: Functions
    public func configurePage(){
        DataBase().parseChosenMovieFromJson(with: id) { (movie) in
            self.chosenMovie = movie
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.nameLabel.text = self.chosenMovie?.title
                self.releaseDateLabel.text = "Release Date: \(self.chosenMovie?.releaseDate ?? "N/A")"
                self.voteAverageLabel.text = "Vote Average: \(self.chosenMovie?.voteAverage ?? 0.0)"
                self.overviewLabel.text = self.chosenMovie?.overview
                
                if let url = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face\(self.chosenMovie?.posterPath ?? "")"){
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        self.posterImageView.image = UIImage(data: imageData)
                    }
                }
                
                if self.chosenMovie?.productionCompanies?.count ?? 0 > 0 {
                    self.productionCompanyNameLabel.text = "\(self.chosenMovie?.productionCompanies?[0].name ?? "N/A") Productions"
                    
                    if let url = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face\(self.chosenMovie?.productionCompanies?[0].logoPath ?? "")"){
                        let data = try? Data(contentsOf: url)
                        if let imageData = data {
                            self.productionCompanyImageView.image = UIImage(data: imageData)
                        } else{
                            self.productionCompanyImageView.image = UIImage(named: "noMovie")
                        }
                        self.productionCompanyImageView.isHidden = false
                    }
                    
                }else{
                    self.productionCompanyImageView.image = UIImage(named: "noMovie")
                    self.productionCompanyImageView.isHidden = false
                    self.productionCompanyNameLabel.text = "Productions: N/A"
                }
            }
        }
    }
    
    private func configureBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
