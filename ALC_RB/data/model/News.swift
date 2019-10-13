//
//  News.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct News: Codable {
    let tourney: String?
    let id: String?
    let caption: String?
    let img: String?
    let content: String?
    let createdAt: Date?
    let updatedAt: Date?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case tourney = "tourney"
        case id = "_id"
        case caption = "caption"
        case img = "img"
        case content = "content"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }
}

typealias NewsArray = [News]

extension NewsArray {
    init?(data: Data) {
        guard let instance = try? ISO8601Decoder.getDecoder().decode([News].self, from: data) else { return nil }
        self = instance
    }
}
