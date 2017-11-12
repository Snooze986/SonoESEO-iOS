//
//  CalendarCell.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 27/10/2017.
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

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    private var date: String = ""
    
    func updateUI(date: String, isBlackColor: Bool){
        self.date = date
        lblDate.text = self.date.capitalized
        
        viewBackground.layer.cornerRadius = viewBackground.frame.width/2.0
        viewBackground.layer.masksToBounds = true
        viewBackground.backgroundColor = UIColor.clear
        
        if(!isBlackColor){
            lblDate.textColor = UIColor.lightGray
        } else {
            lblDate.textColor = UIColor.init(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        }
    }
    
    public func getDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = APIConstants.API_FORMAT
    
        let dateComponent = dateFormatter.string(from: date).components(separatedBy: "-")
        let stringDate = dateComponent[0] + "-" + dateComponent[1] + "-" + self.date
        
        return dateFormatter.date(from: stringDate)!
    }
    
    public func setBackgroundSelected(){
        viewBackground.backgroundColor = UIColor(red: 253/255, green: 160/255, blue: 96/255, alpha: 1)
        lblDate.textColor = UIColor.white
    }
    
    public func setActive(){
        viewBackground.backgroundColor = UIColor(red: 0/255, green: 129/255, blue: 255/255, alpha: 1)
        lblDate.textColor = UIColor.white
    }
}
