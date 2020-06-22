//
//  Utilities.swift
//  The Movie DB
//
//  Created by Raz on 20/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

//MARK: Extention - Dismiss Keyboard by touching anywhere extension
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
