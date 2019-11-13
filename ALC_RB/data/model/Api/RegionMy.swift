//
//  Regions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct RegionMy: Codable {
    var _id: String
    var name: String
    var __v: Int
    
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case name = "name"
//        case v = "__v"
//    }
}

extension RegionMy: CellModel { }
