//
//  PastLeague.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct _PastLeague: Codable {
    let name: String?
    let tourney: String?
    let teamName: String?
    let id: String? // league id
    let place: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case tourney = "tourney"
        case teamName = "teamName"
        case place = "place"
    }
}
