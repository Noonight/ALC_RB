//
//  SinglePerson.swift
//  ALC_RB
//
//  Created by ayur on 16.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct SinglePerson: Codable {
    var person: Person
    
    enum CodingKeys: String, CodingKey {
        case person
    }
}
