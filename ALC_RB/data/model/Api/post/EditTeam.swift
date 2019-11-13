//
//  EditTeam.swift
//  ALC_RB
//
//  Created by ayur on 11.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct EditTeam : Codable {
    
    var _id = ""
    var teamId = ""
    var players = EditTeam.Players()
//    var teamName = ""
    
    init(_id: String, teamId: String, players: EditTeam.Players) {
        self._id = _id
        self.teamId = teamId
//        self.teamName = teamName
        self.players = players
    }
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case teamId = "teamId"
//        case teamName = "teamName"
        case players = "players"
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toParams() -> [String: Any] {
        return [
            Fields._id.value() : self._id,
            Fields.teamId.value() : self.teamId,
            Fields.players.value() : self.players.getArrayOfPlayersInDictionary()
        ]
    }

    enum Fields: String {
        case _id = "_id"
        case teamId = "teamId"
        case players = "players"
        
        func value() -> String {
            return self.rawValue
        }
    }
    
    struct Players: Codable {
        var players: [Player]
        
        enum CodingKeys: String, CodingKey {
            case players = "players"
        }
        
        func toDictionary() -> [String: Any] {
            var players: [Any] = []
            for player in self.players {
                players.append(player.toDictionary())
            }
            return [
                CodingKeys.players.rawValue : players
            ]
        }
        
        func getArrayOfPlayersInDictionary() -> [Any] {
            var players: [Any] = []
            for player in self.players {
                players.append(player.toDictionary())
            }
            return players
        }
    }
}

extension EditTeam.Players {
    init() {
        players = []
    }
    init(data: Data) throws {
        self =  try JSONDecoder().decode(EditTeam.Players.self, from: data)
    }
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        players: [Player]? = nil
        ) -> EditTeam.Players {
        return EditTeam.Players(
            players: players ?? self.players
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
