//
//  TourneyDB.swift
//  ALC_RB
//
//  Created by mac on 18.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
//import RealmSwift
//
//class TourneyRealm: Object {
//
//    @objc dynamic var id: String = ""
//
////    let creator = RealmOptional<IdRefObjectWrapper<Person>>() // not supported
////    let region = RealmOptional<IdRefObjectWrapper<RegionMy>>()
//     @objc dynamic var creator: Data? = nil
//     @objc dynamic var region: Data? = nil
////    @objc dynamic var creator: String? = nil
////    @objc dynamic var region: String? = nil
//    @objc dynamic var name: String? = nil
//
//    let maxTeams = RealmOptional<Int>()
//    let maxPlayersInMatch = RealmOptional<Int>()
//
//    @objc dynamic var transferBegin: Date? = nil
//    @objc dynamic var transferEnd: Date? = nil
//    @objc dynamic var beginDate: Date? = nil
//    @objc dynamic var endDate: Date? = nil
//    @objc dynamic var drawDateTime: Date? = nil
//
//    @objc dynamic var mainReferee: Data? = nil // = RealmOptional<IdRefObjectWrapper<Person>.toData()>()
////    @objc dynamic var mainReferee: String? = nil
//
//    let playersMin = RealmOptional<Int>()
//    let playersMax = RealmOptional<Int>()
//
//    let yellowCardsToDisqual = RealmOptional<Int>()
//    let ageAllowedMin = RealmOptional<Int>()
//    let ageAllowedMax = RealmOptional<Int>()
//    let canBeAddNonPlayed = RealmOptional<Bool>()
//    let canBeDeleteNonPlayed = RealmOptional<Bool>()
//
////    @objc dynamic var players: [IdRefObjectWrapper<Person>]?
////    let players = List<IdRefObjectWrapper<Person>.toData()>()
////    let players = List<String>()
//    let players = List<Data>()
//
//    let v = RealmOptional<Int>()
//
//    func toTourney() -> Tourney {
//
//        var tourney = Tourney()
//        tourney.id = self.id
//
//        tourney.creator = IdRefObjectWrapper<Person>.fromData(data: creator)
//        tourney.region = IdRefObjectWrapper<RegionMy>.fromData(data: region)
//        tourney.name = self.name
//
//        tourney.maxTeams = self.maxTeams.value
//        tourney.maxPlayersInMatch = self.maxPlayersInMatch.value
//
//        tourney.transferBegin = self.transferBegin
//        tourney.transferEnd = self.transferEnd
//        tourney.beginDate = self.beginDate
//        tourney.endDate = endDate
//
//        tourney.mainReferee = IdRefObjectWrapper<Person>.fromData(data: mainReferee)
//
//        tourney.playersMin = playersMin.value
//        tourney.playersMax = playersMax.value
//        tourney.canBeAddNonPlayed = canBeAddNonPlayed.value
//        tourney.canBeDeleteNonPlayed = canBeDeleteNonPlayed.value
//
//        tourney.players = players.map { IdRefObjectWrapper<Person>.fromData(data: $0)! }
//
//        tourney.v = v.value
//
//        return tourney
//    }
//
//}
