//
//  News.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct News: Codable {
    
    let id: String
    
    let caption: String? = nil
    let img: String? = nil
    let content: String? = nil
    
    let tourney: IdRefObjectWrapper<Tourney>? = nil
    
    let createdAt: Date? = nil
    let updatedAt: Date? = nil
    let v: Int? = nil

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case caption = "caption"
        case img = "img"
        case content = "content"
        
        case tourney = "tourney"
        
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }
}
