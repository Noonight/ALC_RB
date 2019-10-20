//
//  Match.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 18.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct _Match: Codable {
    let id: String?
    let date: Date?
    
    let league: String?
    let teamOne: String?
    let teamTwo: String?
    
    let stage: Int?
    let tour: String?
    let round: String?
    let group: String?
    
    let played: Bool?
    let events: [_Event]?
    let playersList: [String]?
    let referees: [_Referee]?
    let place: String?
    let winner: String?
    let score: String?
    let fouls: String?
    let autoGoals: String?
    
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date, stage, played, round, group, tour, playersList, place, winner, score, fouls, autoGoals, league, teamOne, teamTwo, events, referees, createdAt, updatedAt
        case v = "__v"
    }
}
