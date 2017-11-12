//
//  Content.swift
//  Sono ESEO
//
// This class contain every data used in the application.
// When the data is loaded, every Controller will look for this variables.
//
//  Created by Sonasi KATOA on 30/04/2017.
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

class Content {
    
    // Sort variables.
    public static var categorized: Bool = false
    public static var ascendingSort: Bool = true
    
    // The user object.
    public static var user: User? = nil
    
    // The list of articles (Could be notification or news).
    public static var articles = [Article]()
    
    // The list of mates in the directory.
    public static var directory = [Mate]()
    
    // The list of activities.
    public static var activities = [Activity]()
    
    // The selected activity
    public static var activity: Activity? = nil
    
    // The selected service
    public static var service: Int = 0
}
