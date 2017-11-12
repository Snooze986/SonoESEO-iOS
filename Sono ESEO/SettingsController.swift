//
//  SettingsController.swift
//  Sono ESEO
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

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsConstants.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? SettingsConstants.access.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsConstants.sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        switch indexPath.section {
            case 0:
                cell.textLabel?.text = SettingsConstants.access[indexPath.row]["name"]
            case 1:
                cell.textLabel?.text = SettingsConstants.contact["name"]
            default:
                cell.textLabel?.text = SettingsConstants.about["name"]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // If the user want to quickly access to a website.
        if(indexPath.section == 0){
            UIApplication.shared.open(URL.init(string: SettingsConstants.access[indexPath.row]["link"]!)!, options: [:], completionHandler: nil)
        } else {
            // The alertViews for Contact and About.
            var title: String = SettingsConstants.about["title"]!
            var message: String = SettingsConstants.about["content"]!
            if(indexPath.section == 1){
                title = SettingsConstants.contact["title"]!
                message = SettingsConstants.contact["content"]!
            }
            Alert.alert(view: self, title: title, message: message)
        }
    }
}
