//
//  ServicesController.swift
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

protocol ServicesControllerDelegate: class {
    func reloadData()
}


class ServicesController: UIViewController, ServicesControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    public var services = [String: [Activity]]()
    public var sections = [String]()
    
    var date: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = APIConstants.API_FORMAT
        let dateString = dateFormatter.string(from: date)
        date = dateFormatter.date(from: dateString)!
        
        // If the data contained in the Content is empty, we load it from CoreData.
        if(Content.activities.isEmpty && APICore.getInstance().hasCoreData()){
            loadCore()
        } else {
            getSections()
            tableView.reloadData()
        }
        
        // If it not already done, we refresh activities from the API.
        if(!APIConstants.ACTIVITIES_LOADED){
            load()
            APIConstants.ACTIVITIES_LOADED = true
        }
    }
    
    /**
     This function load data from CoreData in a DispatchQueue.main.async because
     functions using CoreData must be call by the main Thread.
     */
    private func loadCore(){
        DispatchQueue.main.async {
            // Set variable used to decode the JSON and create objects.
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let data = APICore.getInstance().get(type: APIConstants.CORE_ACTIVITIES).data(using: .utf8)
            let obj = try? decoder.decode(ActivityResult.self, from: data!)
            if(obj != nil){
                Content.activities = (obj?.data)!
                
                self.getSections()
                self.tableView.reloadData()                
            }
        }
    }
    
    /**
     This function simply load Activities from the API.
     It ask data from API_ACTIVITIES and then create an array of activities using
     Swift4 Json parsing and Structures.
     */
    private func load(){
        let args: String = "login=\(Content.user!.login!)&token=\(Content.user!.token!)"
        APIClient.getInstance().request(link: APIConstants.API_ACTIVITIES, args: args,  completed : { (data) in
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let obj = try? decoder.decode(ActivityResult.self, from: data)
            if(obj?.status != 2){
                // Save the new Articles to Content and CoreData.
                Content.activities = (obj?.data)!
                let stringData = String(data: data, encoding: .utf8)
                
                self.getSections()
                
                // Refresh the list of Articles.
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_ACTIVITIES, data: stringData!)
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    Alert.alert(view: self, title: "Erreur",
                                message: "Erreur lors de la communication avec le serveur.\nVeuillez vérifier votre connexion.")
                }
            }
        }, failed : { (data) in
            DispatchQueue.main.async {
                Alert.alert(view: self, title: "Erreur",
                            message: "Erreur lors de la communication avec le serveur. \nVeuillez vérifier votre connexion.")
            }
        })
    }
    
    // Reload data after popup change.
    func reloadData(){
        getSections()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /*
     * This function generate the sections and activities in the corresponding section.
     */
    private func getSections() {
        sections.removeAll()
        services.removeAll()
        
        // Date formatter to get the section : Month Year.
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM yyyy"
        
        // Then we generate our array with the section as key and services as values.
        var section: String = ""
        for activity in Content.activities {
            if(activity.type == .service && (activity.date != nil && activity.date! >= date)){
                section = dateFormatter.string(from: activity.date!).capitalized
                if(services[section] == nil){
                    services[section] = [Activity]()
                }
                services[section]!.append(activity)
            }
        }
        
        // We sort sections by ascending order. (Ascending date)
        sections = services.keys.sorted{ (key1, key2) -> Bool in
            return dateFormatter.date(from: key1)!.compare(dateFormatter.date(from: key2)!) == ComparisonResult.orderedAscending
        }
        for item in sections {
            services[item] = services[item]?.sorted{ (activity1, activity2) -> Bool in
                return activity1.date!.compare(activity2.date!) == ComparisonResult.orderedAscending
            }
        }
    }
}

extension ServicesController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.updateUI(activity: services[sections[indexPath.section]]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let activity = services[sections[indexPath.section]]![indexPath.row]
        if(!Content.activities.isEmpty){
            for i in 0...Content.activities.count-1 {
                if(Content.activities[i] == activity){
                    Content.service = i
                }
            }
        }
        let controller: ServicePopup = self.storyboard?.instantiateViewController(withIdentifier: "ServicePopup") as! ServicePopup
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}
