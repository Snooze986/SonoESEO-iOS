//
//  MaterialController.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 18/05/2017.
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

class MaterialController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var activity: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...Content.activities.count - 1 {
            if(Content.activities[i] == Content.activity){
                activity = i
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(Content.activities[activity].material != nil){
            return Content.activities[activity].material!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MaterialCell = tableView.dequeueReusableCell(withIdentifier: "MaterialCell", for: indexPath) as! MaterialCell
        cell.update(material: Content.activities[activity].material![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        Content.activities[activity].material![indexPath.row].selected = Content.activities[activity].material![indexPath.row].selected ?? 0
        
        Content.activities[activity].material![indexPath.row].selected! += 1
        if(Content.activities[activity].material![indexPath.row].selected! == 3){
            Content.activities[activity].material![indexPath.row].selected! = 0
        }
        
        tableView.reloadData()
    }
}
