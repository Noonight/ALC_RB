//
//  File.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire

struct Tourney: Codable {
    
    let id: String
    
    var creator: IdRefObjectWrapper<Person>?
    var region: IdRefObjectWrapper<RegionMy>?
    var name: String?
    
    var maxTeams: Int?
    var maxPlayersInMatch: Int?
    
    var transferBegin: Date?
    var transferEnd: Date?
    var beginDate: Date?
    var endDate: Date?
    var drawDateTime: Date?
    
    var mainReferee: IdRefObjectWrapper<Person>?
    
    var playersMin: Int?
    var playersMax: Int?
    
    var yellowCardsToDisqual: Int?
    var ageAllowedMin: Int?
    var ageAllowedMax: Int?
    var canBeAddNonPlayed: Bool?
    var canBeDeleteNonPlayed: Bool?
    
    var players: [IdRefObjectWrapper<Person>]?
    
    var v: Int?

    enum CodingKeys: String, CodingKey {
       
        case id = "_id"
        
        case creator
        case region
        case name
       
        case maxTeams
        case maxPlayersInMatch
        
        case transferBegin
        case transferEnd
        case beginDate
        case endDate
        case drawDateTime
        
        case mainReferee
        
        case playersMin
        case playersMax
        
        case yellowCardsToDisqual
        case ageAllowedMin
        case ageAllowedMax
        case canBeAddNonPlayed
        case canBeDeleteNonPlayed
        
        case players
        
        case v = "__v"
    }
}

enum DateError: String, Error {
    case invalidDate
}
