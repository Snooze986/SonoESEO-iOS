//
//  DirectoryController.swift
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

class DirectoryController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var results = [Mate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the directory from Content variable which have been initialized by CoreData.
        if(Content.directory.isEmpty && APICore.getInstance().hasCoreData()){
            loadCore()
        }
        
        // Refresh address book from the API.
        load()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
            
            let data = APICore.getInstance().get(type: APIConstants.CORE_DIRECTORY).data(using: .utf8)
            let obj = try? decoder.decode(DirectoryResult.self, from: data!)
            if(obj != nil){
                Content.directory = (obj?.data)!
                
                self.filter(search: "")
            }
        }
    }
    
    /*
     * This function simply load Directory from the API.
     * It ask data from API_DIRECTORY and then create an array of directory using
     * Swift4 Json parsing and Structures.
     */
    private func load(){
        let args: String = "login=\(Content.user!.login!)&token=\(Content.user!.token!)"
        APIClient.getInstance().request(link: APIConstants.API_DIRECTORY, args: args,  completed : { (data) in
            let decoder = JSONDecoder()
            let obj = try? decoder.decode(DirectoryResult.self, from: data)
            if(obj?.status != 2){
                // Save the new Articles to Content and CoreData.
                Content.directory = (obj?.data)!
                let stringData = String(data: data, encoding: .utf8)
                
                // Refresh the list of mates in the Directory
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_DIRECTORY, data: stringData!)
                    self.filter(search: self.searchBar.text!)
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
    
    // Calls this function when the tap is recognized, hide the keyboard.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // When user write in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(search: searchBar.text!)
    }
    
    /*
     * This function filter the Directory according to the research.
     * @search : The name of the person researched.
     */
    func filter(search: String) {
        results.removeAll()
        
        if(!Content.directory.isEmpty){
            if(search.isEmpty){
                results = Content.directory
            } else {
                for mate in Content.directory {
                    if(mate.name!.lowercased().contains(search.lowercased())){
                        results.append(mate)
                    }
                }
            }
        }
        // Sort the list of results by alphabetical order.
        results = results.sorted(by: {$0.name!.lowercased() < $1.name!.lowercased()})
        tableView.reloadData()
    }
    
}


extension DirectoryController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryCell", for: indexPath) as! DirectoryCell
        cell.updateUI(mate: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller: DirectoryPopup = self.storyboard?.instantiateViewController(withIdentifier: "DirectoryPopup") as! DirectoryPopup
        controller.setMate(mate: results[indexPath.row])
        self.present(controller, animated: true, completion: nil)
    }
}
