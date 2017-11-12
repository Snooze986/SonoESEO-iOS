//
//  Alert.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 23/10/2017.
//  Copyright © 2017 Sonasi KATOA. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see http://www.gnu.org/licenses/

import UIKit

class Alert {
    
    /**
     This function will open a UIAlertController according to given parameters.
     
     @param title The title of the UIAlertController
     @param message The content of the UIAlertController
     */
    public static func alert(view: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: ".Ok", style: .default) {
            (action: UIAlertAction!) -> Void in
        }
        alert.addAction(cancelAction)
        view.present(alert, animated: true, completion: nil)
    }
}
