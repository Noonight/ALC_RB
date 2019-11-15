//
//  Player.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 15.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Player: Codable {
    var inviteStatus: String
    var number: String
    var activeYellowCards, yellowCards, redCards, activeDisquals: Int
    var disquals, matches, goals: Int
    var id, playerID: String
    
    init() {
        inviteStatus = InviteStatus.pending.rawValue
        number = ""
        activeYellowCards = -1
        yellowCards = -1
        redCards = -1
        activeDisquals = -1
        disquals = -1
        matches = -1
        goals = -1
        id = ""
        playerID = ""
    }
    
    func toDictionary() -> [String: Any] {
        return [
            CodingKeys.inviteStatus.rawValue : inviteStatus,
            CodingKeys.number.rawValue : number,
            CodingKeys.activeYellowCards.rawValue : activeYellowCards,
            CodingKeys.yellowCards.rawValue : yellowCards,
            CodingKeys.redCards.rawValue : redCards,
            CodingKeys.activeDisquals.rawValue : activeDisquals,
            CodingKeys.disquals.rawValue : disquals,
            CodingKeys.matches.rawValue : matches,
            CodingKeys.goals.rawValue : goals,
            CodingKeys.id.rawValue : id,
            CodingKeys.playerID.rawValue : playerID
        ]
    }
    
    func getInviteStatus() -> InviteStatus {
        if inviteStatus.contains(InviteStatus.accepted.rawValue) {
            return InviteStatus.accepted
        }
        if inviteStatus.contains(InviteStatus.approved.rawValue) {
            return InviteStatus.approved
        }
        if inviteStatus.contains(InviteStatus.rejected.rawValue) {
            return InviteStatus.rejected
        }
        if inviteStatus.contains(InviteStatus.pending.rawValue) {
            return InviteStatus.pending
        }
        return .noData
    }
    
    enum CodingKeys: String, CodingKey {
        case inviteStatus, number, activeYellowCards, yellowCards, redCards, activeDisquals, disquals, matches, goals
        case id = "_id"
        case playerID = "playerId"
    }
}

enum InviteStatus: String, Codable {
    case accepted = "Accepted"
    case approved = "Approved"
    
    case rejected = "Rejected"
    case pending = "Pending"
    
    case noData = "No data"
}


extension Player {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Player.self, from: data)
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
        inviteStatus: String? = nil,
        number: String? = nil,
        activeYellowCards: Int? = nil,
        yellowCards: Int? = nil,
        redCards: Int? = nil,
        activeDisquals: Int? = nil,
        disquals: Int? = nil,
        matches: Int? = nil,
        goals: Int? = nil,
        id: String? = nil,
        playerID: String? = nil
        ) -> Player {
        var player = Player()
        player.inviteStatus = inviteStatus ?? self.inviteStatus
        player.number = number ?? self.number
        player.activeYellowCards = activeYellowCards ?? self.activeYellowCards
        player.yellowCards = yellowCards ?? self.yellowCards
        player.redCards = redCards ?? self.redCards
        player.activeDisquals = activeDisquals ?? self.activeDisquals
        player.inviteStatus = inviteStatus ?? self.inviteStatus
        player.disquals = disquals ?? self.disquals
        player.number = number ?? self.number
        player.matches = matches ?? self.matches
        player.goals = goals ?? self.goals
        player.id = id ?? self.id
        player.playerID = playerID ?? self.playerID
        return player
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
