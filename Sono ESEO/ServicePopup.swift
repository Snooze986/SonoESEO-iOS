//
//  ServicePopup.swift
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

class ServicePopup: UIViewController {
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblDateEnd: UILabel!
    @IBOutlet weak var lblHourEnd: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var btnValide: UIButton!
    @IBOutlet weak var btnUnvalaible: UIButton!
    
    @IBOutlet weak var bgExit: UIView!
    
    private var activity: Activity? = nil
    
    weak var delegate: ServicesControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activity = Content.activities[Content.service]
        
        lblTitle.text = activity!.title ?? ActivitiesConstants.EMPTY_FIELD
        
        lblPlace.text = activity!.place ?? ActivitiesConstants.EMPTY_FIELD
        
        lblHour.text = ActivitiesConstants.EMPTY_FIELD
        if(activity!.hour != nil){
            let hourComponent = activity!.hour!.components(separatedBy: ":")
            lblHour.text = hourComponent[0] + " H " + hourComponent[1]
        }
        
        lblHourEnd.text = ActivitiesConstants.EMPTY_FIELD
        if(activity!.hourEnd != nil){
            let hourEndComponent = activity!.hourEnd!.components(separatedBy: ":")
            lblHourEnd.text = hourEndComponent[0] + " H " + hourEndComponent[1]
        }
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.current
        dateformatter.dateFormat = "EEEE dd MMMM y"
        
        lblDate.text = ActivitiesConstants.EMPTY_FIELD
        if(activity!.date != nil){
            lblDate.text = dateformatter.string(from: activity!.date!).capitalized
        }
        
        lblDateEnd.text = ActivitiesConstants.EMPTY_FIELD
        if(activity!.dateEnd != nil){
            lblDate.text = dateformatter.string(from: activity!.dateEnd!).capitalized
        }
        
        lblState.text = ActivitiesConstants.EMPTY_FIELD
        if(activity!.state != nil){
            switch activity!.state! {
                case 0:
                    lblState.text = "Non inscrit."
                case 1:
                    lblState.text = "Validé."
                case 2:
                    lblState.text = "Inscrit, en attente de validation."
                default:
                    lblState.text = "Vous êtes indisponible."
            }
        }
        
        // Set a blue gradient for the background.
        let topColor: CGColor = UIColor(red: 34/255, green: 34/255, blue: 128/255, alpha: 1).cgColor
        let botColor: CGColor = UIColor(red: 62/255, green: 148/255, blue: 214/255, alpha: 1).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [topColor, botColor]
        viewBackground.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func unavailable(_ sender: AnyObject){
        if(activity!.id != nil && activity!.state != 3){
            let link = APIConstants.API_SERVICE
            let args = "login=\(Content.user!.login!)&token=\(Content.user!.token!)&service=\(activity!.id!)&state=3"
            APIClient.getInstance().request(link: link, args: args, completed: { data in
                Content.activities[Content.service].state = 3
                self.delegate?.reloadData()
                self.dismiss(animated: true, completion: {})
            }, failed: { data in
                Alert.alert(view: self, title: "Erreur", message: "Erreur lors de la communication avec le serveur. \nVeuillez vérifier votre connexion.")
            })
        } else {
            Alert.alert(view: self, title: "Erreur", message: "Vous êtes déjà marqué comme indisponible pour cette prestation.")
        }
    }
    
    @IBAction func available(_ sender: AnyObject) {
        if(activity!.id != nil && activity!.state != 2 && activity!.state! != 1){
            let link = APIConstants.API_SERVICE
            let args = "login=\(Content.user!.login!)&token=\(Content.user!.token!)&service=\(activity!.id!)&state=2"
            APIClient.getInstance().request(link: link, args: args, completed: { data in
                Content.activities[Content.service].state = 2
                self.delegate?.reloadData()
                self.dismiss(animated: true, completion: {})
            }, failed: { data in
                Alert.alert(view: self, title: "Erreur", message: "Erreur lors de la communication avec le serveur. \nVeuillez vérifier votre connexion.")
            })
        } else {
            Alert.alert(view: self, title: "Erreur", message: "Vous êtes déjà marqué comme disponible ou validé pour cette prestation.")
        }
    }
    
    @IBAction func dismissController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }    
}
