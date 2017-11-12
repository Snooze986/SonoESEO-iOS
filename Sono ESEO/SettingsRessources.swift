//
//  SettingsRessources.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 30/04/2017.
//  Copyright © 2017 Sonasi KATOA. All rights reserved.
//

import Foundation

class SettingsRessources {
    public static let VERSION = "2.0"
    
    public static let sections = ["Accès rapide", "Contact", "À propos"]
    
    public static let fastAccess = [["name":"Facebook", "link":"https://www.facebook.com/sonoeseo/"], ["name": "Site sonoeseo.com", "link":"http://sonoeseo.com/"], ["name": "Sylapse", "link":"http://sylapse.sonoeseo.com/"]]
    public static let contact = ["name":"Contact", "title":"Contact", "content": "Développeur : KATOA Sonasi 🐑\n\nMail : s.katoa@sonoeseo.com"]
    public static let about = ["name":"À propos", "title":"À propos", "content": getAbout()]
    
    public static func getAbout() -> String {
        return "Version \(SettingsRessources.VERSION)\n\n" +
            "Application : SONO ESEO\n" +
            "Merci à Papy pour sa coopération sur Sylapse\n\n" +
        "© KATOA Sonasi \(getCurrentYear())"
    }
    
    private static func getCurrentYear() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: date as Date)
        
        return components.year!
    }
    
}
