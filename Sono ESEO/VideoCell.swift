//
//  VideoCell.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 30/04/2017.
//  Copyright © 2017 Sonasi KATOA. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageAuthor: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    public func updateUI(article: Article){
        labelAuthor.text = article.getAuthor()
        labelType.text = article.getType()
        labelTitle.text = article.getTitle()
        
        if(!article.getAuthorAvatar().isEmpty){
            imageAuthor.sd_setImage(with: URL(string: StringRessources.API_AVATAR+article.getAuthorAvatar())!, placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imageAuthor.image = UIImage(named: "ic_userBlack")
        }
        
        ViewDesign.setBorderView(view: viewBackground)
        ViewDesign.setShadowView(view: viewBackground)
        
        ImageDesign.setRoundImage(img: imageAuthor)
    }
    
}
