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
    
    var id: String = ""
    
    var creator: IdRefObjectWrapper<Person>? = nil
    var region: IdRefObjectWrapper<RegionMy>? = nil
    var name: String? = nil
    
    var maxTeams: Int? = nil
    var maxPlayersInMatch: Int? = nil
    
    var transferBegin: Date? = nil
    var transferEnd: Date? = nil
    var beginDate: Date? = nil
    var endDate: Date? = nil
    var drawDateTime: Date? = nil
    
    var mainReferee: IdRefObjectWrapper<Person>? = nil
    
    var playersMin: Int? = nil
    var playersMax: Int? = nil
    
    var yellowCardsToDisqual: Int? = nil
    var ageAllowedMin: Int? = nil
    var ageAllowedMax: Int? = nil
    var canBeAddNonPlayed: Bool? = nil
    var canBeDeleteNonPlayed: Bool? = nil
    
    var players: [IdRefObjectWrapper<Person>]? = nil
    
    var v: Int? = nil

    init() {
        id = "_id"
        creator = nil
        region = nil
        name = nil
        maxTeams = nil
        maxPlayersInMatch = nil
        transferBegin = nil
        transferEnd = nil
        beginDate = nil
        endDate = nil
        drawDateTime = nil
        mainReferee = nil
        playersMin = nil
        playersMax = nil
        yellowCardsToDisqual = nil
        ageAllowedMin = nil
        ageAllowedMax = nil
        canBeAddNonPlayed = nil
        canBeDeleteNonPlayed = nil
        players = nil
        v = nil
    }
    
//    func toTourneyRealm() -> TourneyRealm {
//        
//        var tourney = TourneyRealm()
//        tourney.id = self.id
//
//        tourney.creator = creator?.toData()
//        tourney.region = region?.toData()
//        tourney.name = self.name
//
//        tourney.maxTeams.value = self.maxTeams
//        tourney.maxPlayersInMatch.value = self.maxPlayersInMatch
//
//        tourney.transferBegin = self.transferBegin
//        tourney.transferEnd = self.transferEnd
//        tourney.beginDate = self.beginDate
//        tourney.endDate = endDate
//
//        tourney.mainReferee = mainReferee?.toData()
//
//        tourney.playersMin.value = playersMin
//        tourney.playersMax.value = playersMax
//        tourney.canBeAddNonPlayed.value = canBeAddNonPlayed
//        tourney.canBeDeleteNonPlayed.value = canBeDeleteNonPlayed
//
//        players?.forEach { tourney.players.append($0.toData()) }
//
//        tourney.v.value = v
//
//        return tourney
//    }
//
    init(data: Data) throws {
        self = try ISO8601Decoder.getDecoder().decode(Tourney.self, from: data)
    }
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            self.id = try container.decode(String.self, forKey: .id)
//
//            self.creator = try container.decode(IdRefObjectWrapper<Person>.self, forKey: .creator)
//            self.region = try container.decode(IdRefObjectWrapper<RegionMy>.self, forKey: .region)
//            self.name = try container.decode(String.self, forKey: .name)
//
//            self.maxTeams = try container.decode(Int.self, forKey: .maxTeams)
//            self.maxPlayersInMatch = try container.decode(Int.self, forKey: .maxPlayersInMatch)
//
//            self.transferBegin = try container.decode(Date.self, forKey: .transferBegin)
//            self.transferEnd = try container.decode(Date.self, forKey: .transferEnd)
//            self.beginDate = try container.decode(Date.self, forKey: .beginDate)
//            self.endDate = try container.decode(Date.self, forKey: .endDate)
//            self.drawDateTime = try container.decode(Date.self, forKey: .drawDateTime)
//
//            self.mainReferee = try container.decode(IdRefObjectWrapper<Person>.self, forKey: .mainReferee)
//
//            self.playersMin = try container.decode(Int.self, forKey: .playersMin)
//            self.playersMax = try container.decode(Int.self, forKey: .playersMax)
//
//            self.yellowCardsToDisqual = try container.decode(Int.self, forKey: .yellowCardsToDisqual)
//            self.ageAllowedMin = try container.decode(Int.self, forKey: .ageAllowedMin)
//            self.ageAllowedMax = try container.decode(Int.self, forKey: .ageAllowedMax)
//            self.canBeAddNonPlayed = try container.decode(Bool.self, forKey: .canBeAddNonPlayed)
//            self.canBeDeleteNonPlayed = try container.decode(Bool.self, forKey: .canBeDeleteNonPlayed)
//
//            self.players = try container.decode([IdRefObjectWrapper<Person>].self, forKey: .players)
//
//            self.v = try container.decode(Int.self, forKey: .v)
//        } catch {
//            throw DecodingError.typeMismatch(Tourney.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "SHT"))
//        }
//    }
//
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)

            try container.encode(creator, forKey: .creator)
            try container.encode(region?.value, forKey: .region)
//            switch region!.value {
//            case .id(let id):
//                try container.encode(id, forKey: .region)
//            case .object(let obj):
//                try container.encode(obj, forKey: .region)
//            }
            try container.encode(name, forKey: .name)

            try container.encode(maxTeams, forKey: .maxTeams)
            try container.encode(maxPlayersInMatch, forKey: .maxPlayersInMatch)

            try container.encode(transferBegin, forKey: .transferBegin)
            try container.encode(transferEnd, forKey: .transferEnd)
            try container.encode(beginDate, forKey: .beginDate)
            try container.encode(endDate, forKey: .endDate)
            try container.encode(drawDateTime, forKey: .drawDateTime)

            try container.encode(mainReferee, forKey: .mainReferee)

            try container.encode(playersMin, forKey: .playersMin)
            try container.encode(playersMax, forKey: .playersMax)

            try container.encode(yellowCardsToDisqual, forKey: .yellowCardsToDisqual)
            try container.encode(ageAllowedMin, forKey: .ageAllowedMin)
            try container.encode(ageAllowedMax, forKey: .ageAllowedMax)
            try container.encode(canBeAddNonPlayed, forKey: .canBeAddNonPlayed)
            try container.encode(canBeDeleteNonPlayed, forKey: .canBeDeleteNonPlayed)

            try container.encode(players, forKey: .players)

            try container.encode(v, forKey: .v)
        } catch EncodingError.invalidValue(let any, let context) {
//            throw EncodingError.invalidValue(Tourney.self, EncodingError.Context(codingPath: [], debugDescription: "ENCODE SHT"))
            throw EncodingError.invalidValue(any, context)
        } catch {
            Print.m("HZ")
        }
    }
    
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
