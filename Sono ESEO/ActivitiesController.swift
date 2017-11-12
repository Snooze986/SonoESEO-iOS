//
//  ActivitiesController.swift
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

class ActivitiesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var activities = [String: [Activity]]()
    public var sections = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 111
        
        // If the data contained in the Content is empty, we load it from CoreData.
        if(Content.activities.isEmpty && APICore.getInstance().hasCoreData()){
            loadCore()
        } else {
            sort()
        }
        
        // If it not already done, we refresh activities from the API.
        if(!APIConstants.ACTIVITIES_LOADED){
            load()
            APIConstants.ACTIVITIES_LOADED = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(sortPopup), name: NSNotification.Name(rawValue: "sortActivities"), object: nil)
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
                
                self.sort()
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
                
                // Refresh the list of Articles on the main Thread and call CoreData function.
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_ACTIVITIES, data: stringData!)
                    self.sort()
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
    
    /**
     This function will be call by the Popup when the user validate his choices.
     */
    func sortPopup(notification: NSNotification){
        // Load data here
        self.sort()
        self.tableView.reloadData()
    }
    
    /**
     According to the choices of the user, we sort Activities by category or not
     and by ascending/descending dates.
     */
    func sort(){
        sections.removeAll()
        activities.removeAll()
        
        if(Content.categorized){
            var section: String = ""
            for activity in Content.activities {
                if(activity.type! == .service && activities[ActivitiesConstants.SERVICE] == nil){
                    section = ActivitiesConstants.SERVICE
                    activities[section] = [Activity]()
                }
                if(activity.type! == .leasing && activities[ActivitiesConstants.LEASING] == nil){
                    section = ActivitiesConstants.LEASING
                    activities[section] = [Activity]()
                }
                if(activity.type! == .meeting && activities[ActivitiesConstants.MEETING] == nil){
                    section = ActivitiesConstants.MEETING
                    activities[section] = [Activity]()
                }
                activities[section]!.append(activity)
            }
            
            // Sort sections by ascending order.
            sections = activities.keys.sorted()
        } else {
            // Date formatter to get the section : Month Year.
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "MMMM yyyy"
            
            // Then we generate our array with the section as key and services as values.
            var section: String = ""
            for activity in Content.activities {
                section = dateFormatter.string(from: activity.date!).capitalized
                if(activities[section] == nil){
                    activities[section] = [Activity]()
                }
                activities[section]!.append(activity)
            }
            
            if(Content.ascendingSort){
                sections = activities.keys.sorted{ (key1, key2) -> Bool in
                    return dateFormatter.date(from: key1)!.compare(dateFormatter.date(from: key2)!) == ComparisonResult.orderedAscending
                }
            } else {
                sections = activities.keys.sorted{ (key1, key2) -> Bool in
                    return dateFormatter.date(from: key1)!.compare(dateFormatter.date(from: key2)!) == ComparisonResult.orderedDescending
                }
            }
        }
        
        if(Content.ascendingSort){
            for item in sections {
                activities[item] = activities[item]?.sorted{ (activity1, activity2) -> Bool in
                    return activity1.date!.compare(activity2.date!) == ComparisonResult.orderedAscending
                }
            }
        } else {
            for item in sections {
                activities[item] = activities[item]?.sorted{ (activity1, activity2) -> Bool in
                    return activity1.date!.compare(activity2.date!) == ComparisonResult.orderedDescending
                }
            }
        }
    }
    
}


extension ActivitiesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        cell.updateUI(activity: activities[sections[indexPath.section]]![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Set the activity storyboard
        let storyboard = UIStoryboard(name: "Activities", bundle: nil)
        var controller: UIViewController? = nil
        
        Content.activity = self.activities[sections[indexPath.section]]![indexPath.row]
        switch Content.activity!.type! {
            case .service:
                    controller = storyboard.instantiateViewController(withIdentifier: "ServiceController")
            case .leasing:
                controller = storyboard.instantiateViewController(withIdentifier: "LeasingController")
            default:
                controller = storyboard.instantiateViewController(withIdentifier: "MeetingController")
        }
        self.present(controller!, animated: true, completion: nil)
    }
    
}
