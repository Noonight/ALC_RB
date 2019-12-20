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
    
    init(id: String, referees: [Referee]) {
        self.id = id
        self.referees = referees
    }
}

// MARK: - REQUEST PREPARE

extension Match {
    
    var postPlayersList: [String: Any] {
        get {
            var map = [CodingKeys : Any]()
            map[.playersList] = playersList?.map({ person -> String in
                return person.getId() ?? (person.getValue()?.id)!
            })
            
            return map.get()
        }
    }
    
    var patchReferees: [String: Any] {
        get {
            var map = [CodingKeys : Any]()
            map[.id] = id
            map[.referees] = referees.flatMap({ referees -> [[String : Any]] in
                var mArray = [[String:Any]]()
                for referee in referees {
                    var mMap = [Referee.CodingKeys: Any]()
                    //                    mMap[.id] = referee.id
                    mMap[.type] = referee.type?.rawValue
                    mMap[.person] = referee.person?.getId() ?? referee.person?.getValue()?.id
                    mArray.append(mMap.get())
                }
                return mArray
            })
            
            return map.get()
        }
    }
    
}

// MARK: - HELPERS

extension Match {
    
    // requered populated teams
    func getTeamPlayers(team: TeamEnum) -> [IdRefObjectWrapper<Person>] {
        var teamPersons = [IdRefObjectWrapper<Person>]()
        switch team {
        case .one:
            for person in playersList ?? [] {
                for teamPlayer in teamOne!.getValue()!.players ?? [] {
                    if person.getId() ?? person.getValue()?.id == teamPlayer.person?.getId() ?? teamPlayer.person?.getValue()?.id {
                        if teamPersons.contains(where: { pObj -> Bool in
                            return pObj.getId() ?? pObj.getValue()?.id == person.getId() ?? person.getValue()?.id
                        }) == false {
                            teamPersons.append(person)
                        }
                    }
                }
            }
        case .two:
            for person in playersList ?? [] {
                for teamPlayer in teamTwo!.getValue()!.players ?? [] {
                    if person.getId() ?? person.getValue()?.id == teamPlayer.person?.getId() ?? teamPlayer.person?.getValue()?.id {
                        if teamPersons.contains(where: { pObj -> Bool in
                            return pObj.getId() ?? pObj.getValue()?.id == person.getId() ?? person.getValue()?.id
                        }) == false {
                            teamPersons.append(person)
                        }
                    }
                }
            }
        }
        return teamPersons
    }
    
    // required populate teamOne players
    func getEnabledEvents(team: TeamEnum) -> [Event] {
        let enabledEvents = getEnabledEvents()
        
        var findedEvents = [Event]()
        
        switch team {
        case .one:
            let teamOnePlayerEvents = enabledEvents.filter({ event -> Bool in
                return teamOne?.getValue()?.players?.contains(where: { player -> Bool in
                    return player.person?.getId() ?? player.person?.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
                }) ?? false
            })
            let teamOneTeamEvents = enabledEvents.filter({ event -> Bool in
                return event.team?.getId() ?? event.team?.getValue()?.id == teamTwo?.getId() ?? teamOne?.getValue()?.id
            })
            findedEvents.append(contentsOf: teamOnePlayerEvents)
            findedEvents.append(contentsOf: teamOneTeamEvents)
        case .two:
            let teamTwoPlayerEvents = enabledEvents.filter({ event -> Bool in
                return teamTwo?.getValue()?.players?.contains(where: { player -> Bool in
                    return player.person?.getId() ?? player.person?.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
                }) ?? false
            })
            let teamTwoTeamEvents = enabledEvents.filter({ event -> Bool in
                return event.team?.getId() ?? event.team?.getValue()?.id == teamTwo?.getId() ?? teamTwo?.getValue()?.id
            })
            findedEvents.append(contentsOf: teamTwoPlayerEvents)
            findedEvents.append(contentsOf: teamTwoTeamEvents)
        }
        
        return findedEvents
    }
    
    func getEnabledEvents() -> [Event] {
        let disabledEventIds = getDisabledEventIds()
        var enabledEvents = [Event]()
        
        for event in events ?? [] {
            for disabledId in disabledEventIds {
                if event.id != disabledId { // there is check: enable event
                    if enabledEvents.contains(where: { mEvent -> Bool in
                        return mEvent.id == event.id
                    }) == false {
                        enabledEvents.append(event)
                    }
                }
            }
        }
        
        return enabledEvents
    }
    
    func getDisabledEvents() -> [Event] {
        let disabledEventIds = getDisabledEventIds()
        var disabledEvents = [Event]()
        
        for event in events ?? [] {
            for disabledId in disabledEventIds {
                if event.id == disabledId {
                    if disabledEvents.contains(where: { mEvent -> Bool in
                        return mEvent.id == event.id
                    }) == false {
                        disabledEvents.append(event)
                    }
                }
            }
        }
        
        return disabledEvents
    }
    
    func getDisabledEventIds() -> [String] {
        var ids = [String]()
        
        for event in events ?? [] {
            if event.type == .disable && event.event != nil {
                ids.append(event.event!)
            }
        }
        
        return ids
    }
}
