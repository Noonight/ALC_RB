//
//  SingleTeam.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct SingleTeam: Codable {
    var team: Team
    
    enum CodingKeys: String, CodingKey {
        case team
    }
}
