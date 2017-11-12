//
//  SortModal.swift
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

class SortModal: UIViewController {
    
    @IBOutlet weak var switchCategorized: UISwitch!
    @IBOutlet weak var switchAscending: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchCategorized.isOn = Content.categorized
        switchAscending.isOn = Content.ascendingSort
    }
    
    @IBAction func validate(_ sender: AnyObject) {
        Content.ascendingSort = switchAscending.isOn
        Content.categorized = switchCategorized.isOn
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sortActivities"), object: nil)
        self.dismiss(animated: true, completion: {})
    }
    
}
