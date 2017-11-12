//
//  ArticleCell.swift
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

import SDWebImage
import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgAuthorAvatar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var separator: UIView!
    
    /**
     This function will set value to Labels and ImageViews.
     */
    public func updateUI(article: Article){
        lblAuthor.text = article.author ?? ActivitiesConstants.EMPTY_FIELD
        
        lblTitle.text = article.title ?? ActivitiesConstants.EMPTY_FIELD
        
        lblType.text = article.type ?? ActivitiesConstants.EMPTY_FIELD
        lblType.text = lblType.text?.capitalized
        
        lblContent.text = article.content ?? ActivitiesConstants.EMPTY_FIELD
        
        // Load the avatar of author if exitst.
        if(article.authorAvatar != nil && !article.authorAvatar!.isEmpty){
            let avatar = APIConstants.SONO_AVATAR + article.authorAvatar!
            imgAuthorAvatar.sd_setImage(with: URL(string: avatar)!,
                                    placeholderImage: UIImage(named: "ic_userBlack"))
            
            if(imgAuthorAvatar.frame.width == 40.0){
                separator.removeFromSuperview()
            }
        } else {
            imgAuthorAvatar.image = UIImage(named: "ic_userBlack")
        }
        
        ViewDesign.setShadowView(view: viewBackground)
    }
    
}
