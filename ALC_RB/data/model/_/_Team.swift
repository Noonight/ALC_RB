//
//  Team.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

enum _TeamStatus: String, Codable {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
}

// MARK: - _Team
struct _Team: Codable {
    let status: _TeamStatus?
    let place: Int?
    let playoffPlace: Int?
    let madeToPlayoff: Bool?
    let group: String?
    let goals: Int?
    let goalsReceived: Int?
    let wins: Int?
    let losses: Int?
    let draws: Int?
    let groupScore: Int?
    let players: [_Player]?
    let id: String?
    let name: String?
    let creator: String?
    let club: String?
    let trainer: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case place = "place"
        case playoffPlace = "playoffPlace"
        case madeToPlayoff = "madeToPlayoff"
        case group = "group"
        case goals = "goals"
        case goalsReceived = "goalsReceived"
        case wins = "wins"
        case losses = "losses"
        case draws = "draws"
        case groupScore = "groupScore"
        case players = "players"
        case id = "_id"
        case name = "name"
        case creator = "creator"
        case club = "club"
        case trainer = "trainer"
    }
}
