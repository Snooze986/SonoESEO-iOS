//
//  CalendarController.swift
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

class CalendarController: UIViewController {
    
    private static let EMPTY_RESULT = "Aucun résultat"
    private static let ONE_RESULT = " Résultat"
    private static let MANY_RESULTS = " Résultats"
    
    @IBOutlet weak var headerCalendar: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Get device width
    let width = UIScreen.main.bounds.width-24
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblResult: UILabel!
    
    public var date: Date = Date()
    private var dateFormatter: DateFormatter = DateFormatter()
    public var days: [String] = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"]
    public var weekDay: Int = 0
    
    public var results = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        //Define Layout here
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //set section inset as per your requirement.
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //set cell item size here
        layout.itemSize = CGSize(width: width / 7, height: 40)
        
        //set Minimum spacing between 2 items
        layout.minimumInteritemSpacing = 0
        
        //set minimum vertical line spacing here between two lines in collectionview
        layout.minimumLineSpacing = 0
        
        //apply defined layout to collectionview
        collectionView.collectionViewLayout = layout
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM y"
        lblHeader.text = dateFormatter.string(from: date).capitalized
        
        /*
          * We generate the days in a array. That will make a list of days begining by Sunday. So we
          * reorder it by putting Monday as first.
          * -> ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
         */
        days = Array(dateFormatter.shortWeekdaySymbols[1...6])
        days.append(dateFormatter.shortWeekdaySymbols[0])
        
        weekDay = getWeekDay()
        let dF = DateFormatter()
        dF.locale = Locale.current
        dF.dateFormat = "y-MM-dd"
        let dateString = dF.string(from: date)
        date = dF.date(from: dateString)!
        
        if(Content.activities.isEmpty && APICore.getInstance().hasCoreData()){
            loadCore()
        } else {
            collectionView.reloadData()
            reloadResults()
        }
        
        if(!APIConstants.ACTIVITIES_LOADED){
            load()
            APIConstants.ACTIVITIES_LOADED = true
        }
    }
    
    /**
     This function load data from CoreData in a DispatchQueue.main.async because
     functions using CoreData must be call by the main Thread.
     */
    private func loadCore(){
        DispatchQueue.main.async {
            // Set variable used to decode the JSON and create objects.
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let data = APICore.getInstance().get(type: APIConstants.CORE_ACTIVITIES).data(using: .utf8)
            let obj = try? decoder.decode(ActivityResult.self, from: data!)
            if(obj != nil){
                Content.activities = (obj?.data)!
                
                self.collectionView.reloadData()
                self.reloadResults()
            }
        }
    }
    
    /**
     This function simply load Activities from the API.
     It ask data from API_ACTIVITIES and then create an array of activities using
     Swift4 Json parsing and Structures.
     */
    private func load(){
        let args: String = "login=\(Content.user!.login!)&token=\(Content.user!.token!)"
        APIClient.getInstance().request(link: APIConstants.API_ACTIVITIES, args: args,  completed : { (data) in
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = APIConstants.API_FORMAT
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let obj = try? decoder.decode(ActivityResult.self, from: data)
            if(obj?.status != 2){
                // Save the new Articles to Content and CoreData.
                Content.activities = (obj?.data)!
                let stringData = String(data: data, encoding: .utf8)
                
                // Refresh the list of Articles.
                DispatchQueue.main.async {
                    APICore.getInstance().save(type: APIConstants.CORE_ACTIVITIES, data: stringData!)
                    self.collectionView.reloadData()
                    self.reloadResults()
                }
            } else {
                DispatchQueue.main.async {
                    Alert.alert(view: self, title: "Erreur",
                                message: "Erreur lors de la communication avec le serveur.\nVeuillez vérifier votre connexion.")
                }
            }
        }, failed : { (data) in
            DispatchQueue.main.async {
                Alert.alert(view: self, title: "Erreur",
                            message: "Erreur lors de la communication avec le serveur. \nVeuillez vérifier votre connexion.")
            }
        })
    }
    
    // When the user tap on the "Next month" button.
    @IBAction func next(_ sender: AnyObject) {
        // We set the current date to the next month and then, we refresh the header.
        date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
        lblHeader.text = dateFormatter.string(from: date).capitalized
        
        // We refresh the number which define the week day of the first day of the month.
        weekDay = getWeekDay()
        collectionView.reloadData()
    }
    
    // When the user tap on the "Previous Month" button.
    @IBAction func previous(_ sender: AnyObject) {
        // We set the current date to the previous month and then, we refresh the header.
        date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        lblHeader.text = dateFormatter.string(from: date).capitalized
        
        // We refresh the number which define the week day of the first day of the month.
        weekDay = getWeekDay()
        collectionView.reloadData()
    }
    
    /**
     This function reload results. It will show every activity whose selected date is within
     the time interval between the start and the end of the service.
     Then it wil refresh the Label which show how much results is/are there.
     */
    public func reloadResults(){
        results.removeAll()
        
        for activity in Content.activities {
            if(activity.type! != .leasing && (activity.date! <= date && activity.dateEnd! >= date)){
                results.append(activity)
            }
            if(activity.type! == .leasing && (activity.date! == date || activity.dateEnd! == date)) {
                results.append(activity)
            }
        }
        
        if(!results.isEmpty){
            if(results.count == 1){
                lblResult.text = String(results.count) + CalendarController.ONE_RESULT
            } else {
                lblResult.text = String(results.count) + CalendarController.MANY_RESULTS
            }
        } else {
            lblResult.text = CalendarController.EMPTY_RESULT
        }
        tableView.reloadData()
    }
    
    /**
     This function simply get the WeekDay number of the first day of the month.
     But because the app will be used in Europe, we convert the number to european format.
     US : 1 - "Sunday" ; 2 - "Monday" ; 3 - "Tuesday" etc...
     Eur : 1 - "Monday" ; 2 - "Tuesday" ; 3 - "Wednesday" etc...
     */
    public func getWeekDay() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var dateString = dateFormatter.string(from: self.date)
        let dateComponent = dateString.components(separatedBy: "-")
        dateString = dateComponent[0] + "-" + dateComponent[1] + "-01"
        
        let date = dateFormatter.date(from: dateString)
        var weekday = Calendar.current.component(.weekday, from: date!)
        
        if(weekday == 1){
            weekday = 7
        } else {
            weekday = weekday-1
        }
        
        return weekday
    }
    
    /**
     This function will simply return if there is activities for the selected date.
     */
    public func hasActivity(date: Date) -> Bool {
        var result: Bool = false
        for activity in Content.activities {
            if(activity.date != nil && activity.dateEnd != nil){
                if(activity.type! != .leasing && (activity.date! <= date && activity.dateEnd! >= date)){
                    result = true
                }
                if(activity.type! == .leasing && (activity.date! == date || activity.dateEnd! == date)) {
                    result = true
                }
            }
        }
        return result
    }
}

extension CalendarController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /**
     First of all we are verifying if it is a cell for showing day names or a number.
     Then for the Weekdays we show day number from the previous month.
     For the current month we show numbers normally.
     Finally, we count how much numbers are there between the last day of the current month
     and the end of the line.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row < 7){
            let cell: CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarCell
            cell.updateUI(date: days[indexPath.row], isBlackColor: true)
            return cell
        }
        
        var index: Int = indexPath.row - 6
        let cell: CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        if(index < weekDay){
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)!
            let monthSize: Int = (Calendar.current.range(of: .day, in: .month, for: previousMonth)?.count)!
            cell.updateUI(date: "\(monthSize - weekDay + index + 1)", isBlackColor: false)
        } else {
            index = index - weekDay + 1
            let monthSize: Int = (Calendar.current.range(of: .day, in: .month, for: date)?.count)!
            if(index < (monthSize + 1)){
                cell.updateUI(date: "\(index)", isBlackColor: true)
                
                // If this day has activity, we set a colored background.
                if(self.hasActivity(date: cell.getDate(date: date))){
                    cell.setBackgroundSelected()
                }
                if(cell.getDate(date: date) == self.date){
                    cell.setActive()
                }
            } else {
                cell.updateUI(date: "\(index - monthSize)", isBlackColor: false)
            }
        }
        return cell
    }
    
    /**
     The number of items in section are calculated like that :
     7 Items for days names.
     Week Days + Month length
     And the number of items to end the last line.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let maxSize: Int = (weekDay-1) + (Calendar.current.range(of: .day, in: .month, for: date)?.count)!
        return 7 + maxSize + (7 - (maxSize % 7))
    }
    
    /**
     If the user selected one of the days of the previous month, we show the previous month.
     If the user selected one of the days of the next month, we show the next month.
     If the user selected one of the days of the current month, we refresh the results.
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        
        print("Collection width \(collectionView.bounds.size.width)")
        print("Size width \(width)")
        
        
        if(indexPath.row > 6){
            let minLimit = (6 + weekDay)
            let maxLimit = minLimit + (Calendar.current.range(of: .day, in: .month, for: date)?.count)! - 1
            if(indexPath.row < minLimit){
                self.previous(0 as AnyObject)
            } else {
                if(indexPath.row > maxLimit){
                    self.next(0 as AnyObject)
                } else {
                    let cell: CalendarCell = collectionView.cellForItem(at: indexPath) as! CalendarCell
                    self.date = cell.getDate(date: date)
                    
                    self.reloadResults()
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension CalendarController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        cell.updateUI(activity: results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        // Set the activity storyboard
        let storyboard = UIStoryboard(name: "Activities", bundle: nil)
        var controller: UIViewController? = nil
        
        Content.activity = self.results[indexPath.row]
        switch Content.activity!.type! {
            case .service:
                controller = storyboard.instantiateViewController(withIdentifier: "ServiceController")
            case .leasing:
                controller = storyboard.instantiateViewController(withIdentifier: "LeasingController")
            default:
                controller = storyboard.instantiateViewController(withIdentifier: "MeetingController")
        }
        self.present(controller!, animated: true, completion: nil)
    }
 }
