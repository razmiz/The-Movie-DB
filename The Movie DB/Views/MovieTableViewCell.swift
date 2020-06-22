//
//  MovieTableViewCell.swift
//  The Movie DB
//
//  Created by Raz on 19/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: Properties
    public static let identifier = "movieCell"
    let imageCache = NSCache<NSString, UIImage>()
    var highestPopularity = 260.0
    
    //MARK: Outlets
    @IBOutlet weak var posterImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    //MARK: Functions
    public func configureCell(result: Result){
        titleLabel.text = result.title
//        popularityLabel.text = "Popularity: \(result.popularity)"
        //popularity in percents:
        popularityLabel.text = setPopularity(result: result)
        
        posterImageView.loadImageUsingUrlString(urlString: "https://image.tmdb.org/t/p/w440_and_h660_face\(result.posterPath)") { (bool) in
            if !(bool) { print (bool) }
        }
    }
    
    private func setPopularity(result: Result) -> String {
        if result.popularity > highestPopularity{
            highestPopularity = result.popularity
        }
        
        let popularity = String(format: "%.2f", result.popularity * 100.0 / highestPopularity)
        return "Popularity: \(popularity == "100.00" ? "99.99" : popularity)%"
    }
}
