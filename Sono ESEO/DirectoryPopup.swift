//
//  DirectoryPopup.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 29/10/2017.
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
import Contacts
import ContactsUI

class DirectoryPopup: UIViewController, CNContactViewControllerDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    private var mate: Mate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(mate == nil){
            self.dismiss(animated: true, completion: {})
        }
        
        lblName.text = mate!.name ?? ActivitiesConstants.EMPTY_FIELD
        
        lblPhone.text = mate!.phone ?? ActivitiesConstants.EMPTY_FIELD
        
        // Load the avatar of the selected mate.
        if(mate!.avatar != nil && !mate!.avatar!.isEmpty){
            let avatar = APIConstants.SONO_AVATAR + mate!.avatar!
            imgAvatar.sd_setImage(with: URL(string: avatar)!,
                                  placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imgAvatar.image = UIImage(named: "ic_userBlack")
        }
    }
    
    public func setMate(mate: Mate){
        self.mate = mate
    }
    
    @IBAction func add(_ sender: AnyObject) {
        if(self.mate!.phone != nil) {
            let store = CNContactStore()
            let contact = CNMutableContact()
            
            // Get the first name and last name.
            let nameComponent = mate!.name!.components(separatedBy: " ")
            let fName = nameComponent[0].capitalized
            var lName = ""
            for i in 1...nameComponent.count-1 {
                lName += nameComponent[i].capitalized + " "
            }
            lName = lName.substring(to: lName.index(before: lName.endIndex))
            
            // Set first and last name.
            contact.givenName = fName
            contact.familyName = lName
            
            let phone = CNLabeledValue(label: CNLabelPhoneNumberMobile,value: CNPhoneNumber(stringValue: mate!.phone!))
            contact.phoneNumbers = [phone]
            
            let request = CNSaveRequest()
            request.add(contact, toContainerWithIdentifier: nil)
            do{
                try store.execute(request)
                Alert.alert(view: self, title: "Contact ajouté.", message: "Ce contact a bien été ajouté dans votre annuaire.")
            } catch _ {
                Alert.alert(view: self, title: "Erreur", message: "Erreur, le contact n'a pas pu être enregistré dans l'annuaire.")
            }
        }
    }
    
    @IBAction func msg(_ sender: AnyObject) {
        let phone = mate!.phone ?? ""
        UIApplication.shared.open(NSURL(string: "sms:\(phone)")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func call(_ sender: AnyObject) {
        let phone = mate!.phone ?? ""
        UIApplication.shared.open(NSURL(string: "tel:\(phone)")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func exit(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}
