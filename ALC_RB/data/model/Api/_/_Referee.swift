//
//  Referee.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 18.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

enum _RefereeType: String, Codable {
    case first = "1 судья"
    case second = "2 судья"
    case third = "3 судья"
    case chrono = "хронометрист"
}

struct _Referee: Codable {
    let id: String?
    let type: _RefereeType?
    let person: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "type"
        case person = "person"
    }
}
