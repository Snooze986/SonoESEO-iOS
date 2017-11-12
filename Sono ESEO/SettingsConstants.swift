//
//  SettingsConstants.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 24/10/2017.
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

import Foundation

class SettingsConstants {
    
    // The current version of the application.
    public static let VERSION = "2.5"
    
    // The sections of the tableView.
    public static let sections: [String] = ["Accès rapide", "Contact", "À propos"]
    
    // The list of fast access items.
    public static let access: [[String: String]] = [["name":"Facebook", "link":"https://www.facebook.com/sonoeseo/"], ["name": "Site sonoeseo.com", "link":"http://sonoeseo.com/"], ["name": "Sylapse", "link":"http://sylapse.sonoeseo.com/"]]
    
    // The title and content of the Alert for contact.
    public static let contact: [String: String] = ["name":"Contact", "title":"Contact", "content": "Développeur : KATOA Sonasi 🐑\n\nMail : s.katoa@sonoeseo.com"]
    
    // The title and content of the Alert for About.
    public static let about: [String: String] = ["name":"À propos", "title":"À propos", "content": getAbout()]
    
    // Get the content of "About" alert.
    public static func getAbout() -> String {
        return "Version \(SettingsConstants.VERSION)\n\n" +
            "Application : SONO ESEO\n" +
            "Merci à Papy pour sa coopération sur Sylapse\n\n" +
        "© KATOA Sonasi \(getCurrentYear())"
    }
    
    // Get the current year.
    private static func getCurrentYear() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: date as Date)
        
        return components.year!
    }
}
