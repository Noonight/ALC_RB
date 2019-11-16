//
//  DEPRECATED.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

enum _PlayerInviteStatus: String, Codable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}

// MARK: - _Player
struct _Player: Codable {
    let inviteStatus: _PlayerInviteStatus?
    let number: String?
    let activeYellowCards: Int?
    let yellowCards: Int?
    let redCards: Int?
    let activeDisquals: Int?
    let disquals: Int?
    let matches: Int?
    let goals: Int?
    let id: String?
    let playerId: String?

    enum CodingKeys: String, CodingKey {
        case inviteStatus = "inviteStatus"
        case number = "number"
        case activeYellowCards = "activeYellowCards"
        case yellowCards = "yellowCards"
        case redCards = "redCards"
        case activeDisquals = "activeDisquals"
        case disquals = "disquals"
        case matches = "matches"
        case goals = "goals"
        case id = "_id"
        case playerId = "playerId"
    }
}
