//
//  LeasingController.swift
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

class LeasingController: UIViewController{
    
    @IBOutlet weak var informations: UIView!
    @IBOutlet weak var materials: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Content.activity == nil){
            self.dismiss(animated: true, completion: {})
        }
        
        navigationBar.topItem?.title = Content.activity!.title ?? ActivitiesConstants.EMPTY_FIELD
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // When the view appear, we need to hide one of the two views.
        materials.alpha = 0
    }
    
    // This function switch between the two ViewController which compose de UISegmentedControl.
    @IBAction func switchView(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.informations.alpha = 1
                self.materials.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.informations.alpha = 0
                self.materials.alpha = 1
            })
        }
    }
    
    // This function reinitialize the leasing variable and dismiss the current Controller.
    @IBAction func exit(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}
