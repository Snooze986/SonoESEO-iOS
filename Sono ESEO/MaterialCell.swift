//
//  MaterialCell.swift
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

class MaterialCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    func update(material: Material){
        
        lblName.text = material.name ?? ActivitiesConstants.EMPTY_FIELD
        
        lblQuantity.text = "x"
        if(material.quantity != nil){
            lblQuantity.text = "x "+String(material.quantity!)
        }
        
        if(material.selected == nil){
            super.backgroundColor = UIColor.white
        } else {
            switch material.selected! {
            case 0:
                super.backgroundColor = UIColor.white
            case 1:
                super.backgroundColor = UIColor.init(red: 79/255, green: 174/255,
                                                     blue: 84/255, alpha: 1.0)
            default:
                super.backgroundColor = UIColor.init(red: 238/255, green: 50/255,
                                                     blue: 51/255, alpha: 1.0)
            }
        }
    }
}
