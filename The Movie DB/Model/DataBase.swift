//
//  DataBase.swift
//  The Movie DB
//
//  Created by Raz on 19/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import Foundation

class DataBase {
    
    let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=9dbd3b132914c1eed689c91050582fd9&language=en-US&page="
    
    let urlStringForChosenMovie = "https://api.themoviedb.org/3/movie/MOVIE_ID?api_key=9dbd3b132914c1eed689c91050582fd9&language=en-US"
    
    var movie: Movie?
    var chosenMovie: ChosenMovie?
    
    public func parseMovieFromJson(with pageNumber: Int ,completion: @escaping (Movie) -> ()){
        
        if let url = URL(string: urlString + String(pageNumber)) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        self.movie = try
                            JSONDecoder().decode(Movie.self, from: data)
                        completion(self.movie!)
                    } catch let error {
                        print(error)
                    }
                }
                
            }.resume()
        }
    }
    
    public func parseChosenMovieFromJson(with movieID: Int ,completion: @escaping (ChosenMovie) -> ()){
        
        let urlString = urlStringForChosenMovie.replacingOccurrences(of: "MOVIE_ID", with: String(movieID))
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        self.chosenMovie = try
                            JSONDecoder().decode(ChosenMovie.self, from: data)
                        completion(self.chosenMovie!)
                    } catch let error {
                        print(error)
                    }
                }
                
            }.resume()
        }
    }
    
    
}



