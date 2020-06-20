//
//  CustomImageView.swift
//  The Movie DB
//
//  Created by Raz on 20/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    public func loadImageUsingUrlString(urlString: String, completion: @escaping (Bool) -> ()) {
        if let url = URL(string: urlString) {
            if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
                self.image = imageFromCache
                completion(true)
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    completion(false)
                    return
                }
                
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    self.image = imageToCache
                        if imageToCache != nil {
                        imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                    }
                    
                    completion(true)
                }
            }).resume()
        }
    }
}

