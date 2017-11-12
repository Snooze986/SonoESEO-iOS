//
//  APICore.swift
//  Sono ESEO
//
//  The core data are saved as string. We save the string received from the API in an CoreData entity.
//  An amelioration IDEA would be to save CoreData correctly as a real database.
//
//  Created by Sonasi KATOA on 23/10/2017.
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

import CoreData
import UIKit

class APICore {
    
    // Singleton of the class.
    private static let mInstance: APICore = APICore()
    
    // Empty constructor
    init() { }
    
    // Getter for the instance of the singleton.
    public static func getInstance() -> APICore {
        return mInstance
    }
    
    // This function return the Context of the UIApplication.
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.getContext()
    }
    
    /**
     * This function get CoreData.
     */
    public func get(context: NSManagedObjectContext) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sonoeseo")
        do{
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    public func get() -> [Any]? {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sonoeseo")
        do{
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    public func get(type: String) -> String {
        var result: String = ""
        
        let coreData = APICore.getInstance().get()
        if(!(coreData?.isEmpty)!){
            for item in coreData! {
                let values = item as? NSManagedObject
                if(values?.value(forKey: type) != nil){
                    result = (values?.value(forKey: type) as! String)
                }
            }
        }
        
        return result
    }
    
    /**
     * This function remove all saved core data.
     */
    public func removeAll(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sonoeseo")
        do{
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch { }
    }
    
    /*
     * This function verify if the user is already logged in the App.
     * If there is CoreData it means that there was a call to API, if not it means that CoreData
     * has been removed.
     */
    public func hasCoreData() -> Bool {
        let context = getContext()
        let coreData = get(context: context)
        if(coreData != nil && !coreData!.isEmpty){
            return true
        }
        return false
    }
    
    /*
     * This function save the data given in argument in the CoreData according to his type.
     */
    public func save(type: String, data: String) {
        let context = getContext()
        
        //Data is in this case the name of the entity
        let entity = NSEntityDescription.entity(forEntityName: "Sonoeseo", in: context)
        let options = NSManagedObject(entity: entity!, insertInto: context)
        
        // Set the data.
        options.setValue(data, forKey: type)
        
        do{
            // Save the modified CoreData to context
            try context.save()
        } catch { }
    }
}
