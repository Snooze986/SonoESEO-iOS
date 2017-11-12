//
//  ArticleController.swift
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

class ArticleController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    private var article: Article? = nil
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgAuthorAvatar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var backgroundAuthor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = article!.title ?? ActivitiesConstants.EMPTY_FIELD
        navigationBar.topItem?.title = article!.title ?? ActivitiesConstants.EMPTY_FIELD
        
        lblAuthor.text = article!.author ?? ActivitiesConstants.EMPTY_FIELD
        
        lblDate.text = ActivitiesConstants.EMPTY_FIELD
        if(article!.date != nil){
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale.current
            dateformatter.dateFormat = "EEEE dd MMMM y"
            lblDate.text = dateformatter.string(from: article!.date!).capitalized
        }
        
        lblContent.text = article!.content ?? ActivitiesConstants.EMPTY_FIELD
        
        if(article!.authorAvatar != nil && !article!.authorAvatar!.isEmpty){
            let link = APIConstants.SONO_AVATAR + (article?.authorAvatar!)!
            imgAuthorAvatar.sd_setImage(with: URL(string: link)!,
                               placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imgAuthorAvatar.image = UIImage(named: "ic_userBlack")
        }
        
        ViewDesign.setShadowView(view: backgroundAuthor)
    }
    
    // Setter for the current Article.
    public func setArticle(article: Article){
        self.article = article
    }
    
    // Dismiss the current controller.
    @IBAction func dismissController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}

