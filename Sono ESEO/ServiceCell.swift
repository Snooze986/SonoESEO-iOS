//
//  ServiceCell.swift
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

class ServiceCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    public func updateUI(activity: Activity){
        
        lblTitle.text = activity.title ?? ActivitiesConstants.EMPTY_FIELD
        
        lblDay.text = ActivitiesConstants.EMPTY_SFIELD
        lblDate.text = ActivitiesConstants.EMPTY_SFIELD
        if(activity.date != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: activity.date!).capitalized
            let endIndex = dayName.index(dayName.startIndex, offsetBy: 3)
            lblDay.text = dayName.substring(to: endIndex).uppercased()
            
            dateFormatter.dateFormat = "dd"
            lblDate.text = dateFormatter.string(from: activity.date!)
        }
        
        lblPlace.text = activity.place ?? ActivitiesConstants.EMPTY_FIELD
        
        switch (activity.state!) {
            case 1:
                imgStatus.image = UIImage(named: "ic_valide_1")
            case 2:
                imgStatus.image = UIImage(named: "ic_valide_2")
            case 3:
                imgStatus.image = UIImage(named: "ic_valide_3")
            default:
                imgStatus.image = UIImage(named: "ic_valide_0")
        }
    }
}
