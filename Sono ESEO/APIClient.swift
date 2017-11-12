//
//  APIClient.swift
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

class APIClient {
    
    // Singleton of the class.
    private static let mInstance = APIClient()
    
    // Empty constructor.
    init(){ }
    
    // Getter for the instance of the singleton.
    public static func getInstance() -> APIClient {
        return mInstance
    }
    
    /**
     This function make a POST request to the API.
     
     @param link : The link of where the request will be make.
     @param args : The post arguments seperated by "&".
     */
    public func request(link: String, args: String, completed: @escaping (Data) -> (),
                        failed: (((String)?) -> ())? = nil){
        var request = URLRequest(url: URL(string: link)!)
        request.httpMethod = "POST"
        request.httpBody = args.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for fundamental networking error
            guard let data = data, error == nil else {
                failed?("Error")
                return
            }
            
            // Check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                failed?("Error")
            }
            
            // If success, we return the received datas.
            completed(data)
        }
        task.resume()
    }
    
    
}
