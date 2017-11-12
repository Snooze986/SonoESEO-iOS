//
//  HourCell.swift
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

class HourCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    func updateUI(date: Date?, hour: String?){
        bgView.layer.cornerRadius = 3.0
        bgView.layer.masksToBounds = false
        
        bgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowOpacity = 0.9
        
        bgView.layer.borderWidth = 1.5
        bgView.layer.borderColor = UIColor.init(red: 31/255, green: 185/255, blue: 233/255, alpha: 1.0).cgColor
        
        lblDate.text = ActivitiesConstants.EMPTY_FIELD
        if(date != nil){
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale.current
            dateformatter.dateFormat = "EEEE dd MMMM y"
            lblDate.text = dateformatter.string(from: date!).capitalized
        }
        
        lblHour.text = ActivitiesConstants.EMPTY_FIELD
        if(hour != nil){
            lblHour.text = hour
        }
    }
    
}
