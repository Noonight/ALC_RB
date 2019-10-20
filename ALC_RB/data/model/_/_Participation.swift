//
//  Participation.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct _Participation: Codable {
    let id: String?
    let league: String?
    let team: String? // league.team id
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case league = "league"
        case team = "team"
    }
}
