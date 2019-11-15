//
//  PendingTeamInvite.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct PendingTeamInvite: Codable {
    let id: String
    let league: String
    let team: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case league = "league"
        case team = "team"
    }
}

extension PendingTeamInvite {
    
    init() {
        id = ""
        league = ""
        team = ""
    }
    
    init(_ id: String,_ league: String,_ team: String) {
        self.id = id
        self.league = league
        self.team = team
    }
    
    init(data: Data) throws {
        self = try ISO8601Decoder.getDecoder().decode(PendingTeamInvite.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: String? = nil,
        league: String? = nil,
        team: String? = nil
        ) -> PendingTeamInvite {
        return PendingTeamInvite(
            id: id ?? self.id,
            league: league ?? self.league,
            team: team ?? self.team
        )
    }
    
    func jsonData() throws -> Data {
//        return try ISO8601Decoder.getDecoder().encode(self)
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
