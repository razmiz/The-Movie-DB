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
    
    //MARK: Outlets
    @IBOutlet weak var posterImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    
    public func configureCell(result: Result){
        titleLabel.text = result.title
        popularityLabel.text = "Popularity: \(result.popularity)"
        
        posterImageView.loadImageUsingUrlString(urlString: "https://image.tmdb.org/t/p/w440_and_h660_face\(result.posterPath)") { (bool) in
            if !(bool) { print (bool) }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
