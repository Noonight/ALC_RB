//
//  Group.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - _Group
struct _Group: Codable {
    let teams: [String?]?
    let id: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case teams = "teams"
        case id = "_id"
        case name = "name"
    }
}
