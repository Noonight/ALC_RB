//
//  PastLeague.swift
//  ALC_RB
//
//  Created by ayur on 24.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

struct PastLeague: Codable {
    
    var name: String
    var tourney: String
    var teamName: String
    var place: String
    var leagueId: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case tourney = "tourney"
        case teamName = "teamName"
        case place = "place"
        case leagueId = "_id"
    }
    
    init() {
        name = ""
        tourney = ""
        teamName = ""
        place = ""
        leagueId = ""
    }
    
    init(name: String, tourney: String, teamName: String, place: String) {
        self.name = name
        self.tourney = tourney
        self.teamName = teamName
        self.place = place
        self.leagueId = ""
    }

    init(data: Data) throws {
        self = try JSONDecoder().decode(PastLeague.self, from: data)
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
        name: String? = nil,
        tourney: String? = nil,
        teamName: String? = nil,
        place: String? = nil
        ) -> PastLeague {
        return PastLeague(
            name: name ?? self.name,
            tourney: tourney ?? self.tourney,
            teamName: teamName ?? self.teamName,
            place: place ?? self.place
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
