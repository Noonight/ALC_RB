//
//  Match.swift
//  ALC_RB
//
//  Created by mac on 14.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Match: Codable {
    
    var id: String
    
    var league: IdRefObjectWrapper<League>? = nil
    var teamOne: IdRefObjectWrapper<Team>? = nil
    var teamTwo: IdRefObjectWrapper<Team>? = nil
    
    var date: Date? = nil
    
    var stage: IdRefObjectWrapper<Stage>? = nil
    
    var round: String? = nil
    var tour: String? = nil
    var group: String? = nil
    
    var place: IdRefObjectWrapper<Stadium>? = nil
    
    var events: [Event]? = nil
    var playersList: [IdRefObjectWrapper<Person>]? = nil
    var referees: [Referee]? = nil
    
    var played: Bool? = nil
    var winner: String? = nil // teamOne, teamTwo, draw
    var score: String? = nil
    var fouls: String? = nil
    var autoGoals: String? = nil
    
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
    var v: Int? = nil

    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        
        case league
        case teamOne
        case teamTwo
        
        case date
        
        case stage
        
        case round
        case tour
        case group
        
        case place
        
        case events
        case playersList
        case referees
        
        case played
        case winner
        case score
        case fouls
        case autoGoals
        
        case createdAt
        case updatedAt
        case v = "__v"
    }
}

extension Match {
    
    init() {
        id = ""
        
        league = nil
        teamOne = nil
        teamTwo = nil
        
        date = nil
        
        stage = nil
        
        round = nil
        tour = nil
        group = nil
        
        place = nil
        
        events = nil
        playersList = nil
        referees = nil
        
        played = nil
        winner = nil
        score = nil
        fouls = nil
        autoGoals = nil
        
        createdAt = nil
        updatedAt = nil
        v = nil
    }
}