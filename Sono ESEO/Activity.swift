//
//  Activity.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 20/05/2017.
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

import Foundation

struct Activity: Codable, Equatable {
    let id: Int?
    let title: String?
    let content: String?
    // The type of the activity, as defined below.
    let type: ActivityType?
    // The mate responsable of the service, leasing or meeting.
    let supervisor: Mate?
    // The client.
    let client: String?
    // The date of begining of the activity.
    let date: Date?
    let hour: String?
    // The date end of begining of the activity.
    var dateEnd: Date?
    let hourEnd: String?
    // The start of the meeting or prestation.
    let start: String?
    // The price and caution.
    let price: String?
    let guarantee: String?
    // The team.
    let team: [Mate]?
    // This list of the material.
    var material: [Material]?
    // The place of the service or meeting.
    let place: String?
    // The address used for the GPS.
    let address: String?
    var state: Int?
    
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id! == rhs.id!
    }
}

enum ActivityType: String, Codable {
    case service, leasing, meeting
}

struct ActivityResult: Codable {
    // The status.
    let status: Int
    
    // The list of Acitivites.
    let data: [Activity]
}
