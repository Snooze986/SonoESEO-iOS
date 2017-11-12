//
//  Mate.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 01/05/2017.
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

struct Mate: Codable {
    let id: Int?
    let name: String?
    let avatar: String?
    let phone: String?
}

struct DirectoryResult: Decodable {
    // The status.
    let status: Int
    
    /// The list of mates.
    let data: [Mate]
}
