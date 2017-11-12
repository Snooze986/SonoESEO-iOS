//
//  UserController.swift
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
import SDWebImage

class UserController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblResp: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = Content.user?.name ?? ActivitiesConstants.EMPTY_FIELD
        lblResp.text = Content.user?.resp ?? ActivitiesConstants.EMPTY_FIELD
        lblPhone.text = Content.user?.phone ?? ActivitiesConstants.EMPTY_FIELD
        lblLogin.text = "@"+(Content.user?.login!)!
        
        if(!(Content.user?.avatar!.isEmpty)!){
            let link = APIConstants.SONO_AVATAR + (Content.user?.avatar!)!
            imgAvatar.sd_setImage(with: URL(string: link)!, placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imgAvatar.image = UIImage(named: "ic_userBlack")
        }
        
        // Refresh user data
        self.load()
    }
    
    /**
     This function simply load User from the API.
     It ask data from API_USER and then create an array of user using
     Swift4 Json parsing and Structures.
     */
    private func load(){
        let args: String = "login=\(Content.user!.login!)&token=\(Content.user!.token!)"
        APIClient.getInstance().request(link: APIConstants.API_USER, args: args,  completed : { (data) in
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let obj = try? decoder.decode(UserResult.self, from: data)
            if(obj?.status != 2){
                // Save the new user to Content and CoreData.
                Content.user = (obj?.data)!
                let stringData = String(data: data, encoding: .utf8)
                
                // Refresh the user on the main Thread and call CoreData function.
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_USER, data: stringData!)
                    
                    self.lblName.text = Content.user?.name ?? ActivitiesConstants.EMPTY_FIELD
                    self.lblResp.text = Content.user?.resp ?? ActivitiesConstants.EMPTY_FIELD
                    self.lblPhone.text = Content.user?.phone ?? ActivitiesConstants.EMPTY_FIELD
                    self.lblLogin.text = "@"+(Content.user?.login!)!
                    
                    if(!(Content.user?.avatar!.isEmpty)!){
                        let link = APIConstants.SONO_AVATAR + (Content.user?.avatar!)!
                        self.imgAvatar.sd_setImage(with: URL(string: link)!, placeholderImage: UIImage(named: "ic_userBlack"))
                    } else {
                        self.imgAvatar.image = UIImage(named: "ic_userBlack")
                    }
                    
                    self.collectionView.reloadData()
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
    
    /*
     * If the user want to disconnect, we delete CoreData and then we redirect him to the Portal.
     */
    @IBAction func disconnect(_ sender: AnyObject) {
        APICore.getInstance().removeAll()
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PortalController")
        self.present(controller, animated: true, completion: nil)
    }
}


extension UserController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Fill the collections according to their content.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
        cell.updateUI(mate: Content.user!.team![indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(Content.user!.team != nil){
            return Content.user!.team!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = 100
        collectionViewSize.height = 100
        return collectionViewSize
    }
}
