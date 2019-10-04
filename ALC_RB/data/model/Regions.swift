//
//  Regions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Regions: Codable {
    var regions: []
}

struct Region: Codable {
    var _id: String?
    var name: String?
    var __v: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case v = "__v"
    }
}

[
    {
        "_id": "5d91bef797e38d2b76064d22",
        "name": "first region",
        "__v": 0
    },
    {
        "_id": "5d91befd97e38d2b76064d23",
        "name": "second region234",
        "__v": 0
    },
    {
        "_id": "5d9704f4dd14d8544b94956f",
        "name": "Пятый регион",
        "__v": 0
    }
]
