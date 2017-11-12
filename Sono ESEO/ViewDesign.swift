//
//  ViewDesign.swift
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

class ViewDesign {

    /**
     This function set the shadow to a view given in parameter.
     
     @param view The view where the shadow will be set.
     */
    public static func setShadowView(view: UIView!){
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.masksToBounds = false
    }
    
    /**
     This function set a gradient to the view. It will set a gradient with colors according
     to a service.
     
     @param view The view where the gradient will be set.
     */
    public static func setServiceGradient(view: UIView!){
        let topColor: CGColor = UIColor(red: 34/255, green: 34/255, blue: 128/255, alpha: 1).cgColor
        let botColor: CGColor = UIColor(red: 62/255, green: 148/255, blue: 214/255, alpha: 1).cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [topColor, botColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /**
     This function set a gradient to the view. It will set a gradient with colors according
     to a meeting.
     
     @param view The view where the gradient will be set.
     */
    public static func setMeetingGradient(view: UIView!){
        let topColor: CGColor = UIColor(red: 124/255, green: 128/255, blue: 250/255, alpha: 1).cgColor
        let botColor: CGColor = UIColor(red: 252/255, green: 110/255, blue: 242/255, alpha: 1).cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [topColor, botColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /**
     This function set a gradient to the view. It will set a gradient with colors according
     to a leasing.
     
     @param view The view where the gradient will be set.
     */
    public static func setLeasingGradient(view: UIView!){
        let topColor: CGColor = UIColor(red: 241/255, green: 100/255, blue: 155/255, alpha: 1).cgColor
        let botColor: CGColor = UIColor(red: 253/255, green: 171/255, blue: 106/255, alpha: 1).cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        gradient.colors = [topColor, botColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}
