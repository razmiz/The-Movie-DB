//
//  MovieDetailsTableViewCell.swift
//  The Movie DB
//
//  Created by Raz on 24/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    public static let identifier = "movieDetailsIdentifier"
    let imageCache = NSCache<NSString, UIImage>()
    var highestPopularity = 260.0
    var movieId = 0
    var chosenMovie: ChosenMovie?
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var productionImageView: UIImageView!
    @IBOutlet weak var productionNameLabel: UILabel!
    
    public func configureCell(chosenMovie: ChosenMovie){
        self.chosenMovie = chosenMovie
                
        releaseDateLabel.text = "Release Date: \(chosenMovie.releaseDate )"
        voteAverageLabel.text = "Vote Average: \(chosenMovie.voteAverage )"
        overviewLabel.text = chosenMovie.overview
        var languages = "Spoken languages: "
        chosenMovie.spokenLanguages.forEach({ (language) in
            languages += "\(language.name) "
        })
        languagesLabel.text = languages
        
        if chosenMovie.productionCompanies?.count ?? 0 > 0 {
            self.productionNameLabel.text = "\(self.chosenMovie?.productionCompanies?[0].name ?? "N/A") Productions"
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w440_and_h660_face\(self.chosenMovie?.productionCompanies?[0].logoPath ?? "")"){
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    self.productionImageView.image = UIImage(data: imageData)
                } else{
                    self.productionImageView.image = UIImage(named: "noMovie")
                }
                self.productionImageView.isHidden = false
            }
            
        }else{
            self.productionImageView.image = UIImage(named: "noMovie")
            self.productionImageView.isHidden = false
            self.productionNameLabel.text = "Productions: N/A"
        }
        
        
    }
}
