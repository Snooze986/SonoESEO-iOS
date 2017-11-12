//
//  LoginController.swift
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

class LoginController: UIViewController {
    
    // TextField used to connect the suer.
    @IBOutlet weak var fieldLogin: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    // Login button.
    @IBOutlet weak var btnLogin: UIButton!
    
    // Scrollview.
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    /*
     * When the user tap anywhere on the view, we dismiss the keyboard.
     * Actually the keyboard could cover the login button, and this function will allow
     * the user to see the login button if he tap on view.
     */
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
    }
    
    // If the user tap on "Continue" of the login field, it will focus on the password field.
    @IBAction func continueLogin(_ sender: UITextField) {
        fieldLogin.resignFirstResponder()
        fieldPassword.becomeFirstResponder()
    }
    
    /*
     * This function is user to connect the user.
     * It can be called the user tap on the login button or when the user tap on "End"
     * on the keyboard button.
     *
     * First we send a request to the API to try to connect the user.
     * If it is ok, we load datas from the API.
     */
    @IBAction func login(_ sender: AnyObject) {
        if(!(fieldLogin.text?.isEmpty)! && !(fieldPassword.text?.isEmpty)!){
            let link = APIConstants.API_LOGIN
            let args = "login=\(fieldLogin.text!)&password=\(fieldPassword.text!)"
            
            APIClient.getInstance().request(link: link, args: args, completed: { data in
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateFormat = APIConstants.API_FORMAT
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let obj = try? decoder.decode(UserResult.self, from: data)
                if(obj?.status == 2 || obj?.data == nil){
                    DispatchQueue.main.async {
                        Alert.alert(view: self, title: "Erreur lors de l'identification", message: "Mauvais identifiants.")
                    }
                } else {
                    // Save the user to Content and CoreData.
                    Content.user = (obj?.data)!
                    let stringData = String(data: data, encoding: .utf8)
                    
                    DispatchQueue.main.async {
                        APICore.getInstance().save(type: APIConstants.CORE_USER, data: stringData!)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "tabBar")
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }, failed: { data in
                DispatchQueue.main.async {
                    Alert.alert(view: self, title: "Erreur",
                                message: "Erreur lors de la communication avec le serveur. \nVeuillez vérifier votre connexion.")
                }
            })
        } else {
            Alert.alert(view: self, title: "Erreur", message: "Veuillez remplir tous les champs.")
        }
    }
    
    /*
     * If the user forgot his password and he top on "Mot de passe oublié ?", we allow him
     * to send an email to sonoeseo@gmail.com.
     */
    @IBAction func forgot(_ sender: UIButton){
        let email = "sonoeseo@gmail.com"
        if let url = URL.init(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /*
     * If the user want to see legal notices.
     */
    @IBAction func legal(_ sender: UIButton){
        let url: URL = URL.init(string: APIConstants.SONO_LEGAL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }    
}
