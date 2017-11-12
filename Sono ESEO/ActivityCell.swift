//
//  ActivityCell
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

class ActivityCell: UITableViewCell {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var imgType: UIImageView!
    
    @IBOutlet weak var imgGradient: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    func updateUI(activity: Activity){
        
        lblTitle.text = activity.title ?? ActivitiesConstants.EMPTY_FIELD

        lblDate.text = ActivitiesConstants.EMPTY_FIELD
        if(activity.date != nil){
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale.current
            dateformatter.dateFormat = "EEEE dd MMMM y"
            lblDate.text = dateformatter.string(from: activity.date!).capitalized
        }
        
        lblContent.text = activity.content ?? ActivitiesConstants.EMPTY_FIELD
        
        switch activity.type {
            case .service?:
                imgType.image = UIImage(named: "ic_prestation")
                imgGradient.image = UIImage(named: "gradientPrestation")
            case .leasing? :
                imgType.image = UIImage(named: "ic_leasing")
                imgGradient.image = UIImage(named: "gradientLeasing")
                if(activity.dateEnd != nil){
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.current
                    dateFormatter.dateFormat = "EEEE dd MMMM y"
                    lblContent.text = ActivitiesConstants.LEASING_END + dateFormatter.string(from: activity.dateEnd!)
                }
            default:
                imgType.image = UIImage(named: "ic_meeting")
                imgGradient.image = UIImage(named: "gradientMeeting")
        }

        ViewDesign.setShadowView(view: viewBackground)
    }
}
