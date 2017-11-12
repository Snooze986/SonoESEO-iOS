//
//  LeasingInformations.swift
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

class LeasingInformations: UIViewController {
    
   @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblResp: UILabel!
    @IBOutlet weak var lblClient: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblGuarantee: UILabel!
    @IBOutlet weak var lblContent: UILabel!

    @IBOutlet weak var bgInformations: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblResp.text = Content.activity!.supervisor!.name ?? ActivitiesConstants.EMPTY_FIELD
        
        let client = Content.activity!.client ?? ActivitiesConstants.EMPTY_FIELD
        lblClient.text = ActivitiesConstants.CLIENT + client
        
        let content = Content.activity!.content ?? ActivitiesConstants.EMPTY_FIELD
        lblContent.text = ActivitiesConstants.CONTENT + content
        
        let price = Content.activity!.price ?? ActivitiesConstants.EMPTY_PRICE
        lblPrice.text = ActivitiesConstants.PRICE + price + "€"
        
        let guarantee = Content.activity!.guarantee ?? ActivitiesConstants.EMPTY_PRICE
        lblGuarantee.text = ActivitiesConstants.GUARANTEE + guarantee + "€"
        
        if(Content.activity!.supervisor!.avatar != nil && !Content.activity!.supervisor!.avatar!.isEmpty){
            let link = APIConstants.SONO_AVATAR + Content.activity!.supervisor!.avatar!
            imgAvatar.sd_setImage(with: URL(string:link)!,
                                  placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imgAvatar.image = UIImage(named: "ic_userBlack")
        }
        
        ViewDesign.setShadowView(view: bgInformations)
    }
}

extension LeasingInformations: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HourCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourCell
        if(indexPath.row == 0){
            cell.updateUI(date: Content.activity!.date,
                          hour: Content.activity!.hour)
        } else {
            cell.updateUI(date: Content.activity!.dateEnd,
                          hour: Content.activity!.hourEnd)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = (collectionViewSize.width-(10))/2.0
        collectionViewSize.height = 55
        return collectionViewSize
    }
}
