//
//  APIConstants.swift
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

import Foundation

class APIConstants {    
    // Is Activies loaded
    public static var ACTIVITIES_LOADED: Bool = false
    
    // the date format received in the Json.
    public static let API_FORMAT: String = "yyyy-MM-dd"
    
    // The list of entity registered in the core data
    public static let CORE_ENTITIES: [String] = [APIConstants.CORE_ACTIVITIES, APIConstants.CORE_ARTICLES, APIConstants.CORE_DIRECTORY, APIConstants.CORE_USER]
    
    // The string for user
    public static let CORE_USER: String = "user"
    
    // The string for articles
    public static let CORE_ARTICLES: String = "articles"
    
    // The string for directory
    public static let CORE_DIRECTORY: String = "directory"
    
    // The string for Activites
    public static let CORE_ACTIVITIES: String = "activities"
    
    // Root of API link.
    private static let API_ROOT = "https://api.sonoeseo.com"
    
    // Link to login.
    public static let API_LOGIN = API_ROOT + "/connect/"
    
    // Link to get news & notifications.
    public static let API_ARTICLES = API_ROOT+"/articles/"
    
    // Link to get the annuaire.
    public static let API_DIRECTORY = API_ROOT+"/directory/"
    
    // Link to get the list of activities including Prestations.
    public static let API_ACTIVITIES = API_ROOT+"/activities/"
    
    // Link to register the push token.
    public static let API_NOTIFICATION = API_ROOT+"/notification/"

    // Link to get the user datas.
    public static let API_USER = API_ROOT+"/user/"
    
    // Link to register the user to the push notification service.
    public static let API_PUSH = API_ROOT+"/iospush/"
    
    // Link to set the user state for a service.
    public static let API_SERVICE = API_ROOT+"/service/"
    
    // Link to sonoeseo.com
    public static let SONO_ROOT = "http://www.sonoeseo.com"
    
    // Link to user's avatar
    public static let SONO_AVATAR = SONO_ROOT + "/img/team/"
    
    // Link to legal notice
    public static let SONO_LEGAL = SONO_ROOT + "/conditions_application.php";
}
