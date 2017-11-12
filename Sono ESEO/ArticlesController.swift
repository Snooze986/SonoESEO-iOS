//
//  ArticlesController.swift
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
import Foundation
import UserNotifications

class ArticlesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the data contained in the Content is empty, we load it from CoreData.
        if(Content.articles.isEmpty && APICore.getInstance().hasCoreData()){
            loadCore()
        }
        
        // Refresh articles from the API.
        load()
        
        // Ask for registering the user to Push NotificationsAPI
        registerNotification()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
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
            
            let data = APICore.getInstance().get(type: APIConstants.CORE_ARTICLES).data(using: .utf8)
            let obj = try? decoder.decode(ArticleResult.self, from: data!)
            
            // If the parsing of the data is nil we can't set it to Content.
            if(obj != nil){
                Content.articles = (obj?.data)!
                
                // Sort the articles by descending dates.
                Content.articles = Content.articles.sorted{ (article1, article2) -> Bool in
                    return article1.date!.compare(article2.date!) == ComparisonResult.orderedDescending
                }
                
                // After loading CoreData we reload the content of the tableView.
                self.tableView.reloadData()
            }
        }
    }
    
    /*
     * Ask the user to register for notification or alert user, that he must
     * activate push notifications in his phone settings.
     */
    private func registerNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            //Parse errors and track state
            if(granted){
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    Alert.alert(view: self, title: "Attention", message: "Pensez à activer les notifications de l'application depuis les paramètres de votre téléphone.")
                })
            }
        }
    }
    
    /*
     * This function simply load Articles from the API.
     * It ask data from API_ARTICLES and then create an array of articles using
     * Swift4 Json parsing and Structures.
     */
    private func load(){
        let args: String = "login=\(Content.user!.login!)&token=\(Content.user!.token!)"
        APIClient.getInstance().request(link: APIConstants.API_ARTICLES, args: args,  completed : { (data) in
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let obj = try? decoder.decode(ArticleResult.self, from: data)
            if(obj?.status != 2){
                // Save the new Articles to Content and CoreData.
                Content.articles = (obj?.data)!
                let stringData = String(data: data, encoding: .utf8)
                
                // Sort the articles by descending dates.
                Content.articles = Content.articles.sorted{ (article1, article2) -> Bool in
                    return article1.date!.compare(article2.date!) == ComparisonResult.orderedDescending
                }
                
                // Refresh the list of Articles on the main Thread and call CoreData function.
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_ARTICLES, data: stringData!)
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
}


extension ArticlesController: UITableViewDataSource, UITableViewDelegate {
    
    /*
     * This function define the number of elements in the section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Content.articles.count
    }
    
    /*
     * This function set the cell for the Article or Notification.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.updateUI(article: Content.articles[indexPath.row])
        return cell
    }
    
    /*
     * This function is called every time, the user select a rown in the tableView.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We deslect the selected item. Remove the light gray background.
        tableView.deselectRow(at: indexPath, animated: false)

        // Initalize the Article controller and present it.
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticleController") as! ArticleController
        controller.setArticle(article: Content.articles[indexPath.row])
        self.present(controller, animated: true, completion: nil)
    }
}
