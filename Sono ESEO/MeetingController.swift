//
//  MeetingController.swift
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

class MeetingController: UIViewController {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblResp: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblEmptyTeam: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var collectionTeam: UICollectionView!
    @IBOutlet weak var collectionHour: UICollectionView!
    
    @IBOutlet weak var bgInformations: UIView!
    @IBOutlet weak var bgTeam: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the selected activity has not been set, we go back to the list of activities.
        if(Content.activity == nil){
            self.dismiss(animated: true, completion: {})
        }
        
        lblResp.text = Content.activity!.supervisor!.name ?? ActivitiesConstants.EMPTY_FIELD
        navigationBar.topItem?.title = Content.activity!.supervisor!.name ?? ActivitiesConstants.EMPTY_FIELD
        
        let room = Content.activity!.place ?? ActivitiesConstants.EMPTY_FIELD
        lblRoom.text = ActivitiesConstants.ROOM + room
        
        let content = Content.activity!.content ?? ActivitiesConstants.EMPTY_FIELD
        lblContent.text = ActivitiesConstants.CONTENT + content
        
        if(Content.activity!.supervisor!.avatar != nil && !Content.activity!.supervisor!.avatar!.isEmpty){
            let link = APIConstants.SONO_AVATAR + Content.activity!.supervisor!.avatar!
            imgAvatar.sd_setImage(with: URL(string:link)!,
                                  placeholderImage: UIImage(named: "ic_userBlack"))
        } else {
            imgAvatar.image = UIImage(named: "ic_userBlack")
        }
        
        if(Content.activity!.team == nil || (Content.activity!.team != nil && (Content.activity!.team?.isEmpty)!)){
            lblEmptyTeam.text = ActivitiesConstants.EMPTY_TEAM
        } else {
            lblEmptyTeam.removeFromSuperview()
        }
        
        ViewDesign.setShadowView(view: bgInformations)
        ViewDesign.setShadowView(view: bgTeam)
    }
    
    // This function dismiss the current Controller.
    @IBAction func exit(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}

extension MeetingController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == collectionHour){
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
        let cell: MateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as! MateCell
        cell.updateUI(mate: Content.activity!.team![indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == collectionTeam && Content.activity!.team != nil){
            return Content.activity!.team!.count
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if(collectionView == collectionHour){
            var collectionViewSize = collectionView.frame.size
            collectionViewSize.width = (collectionViewSize.width-(10))/2.0
            collectionViewSize.height = 55
            return collectionViewSize
        }
        return CGSize(width: 100.0, height: 100.0)
    }
}

