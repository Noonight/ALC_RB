//
//  LocalTourneys.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 07/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RealmSwift

class LocalTourneys {
    
    var realm: Realm?
    
    func getLocalTourneys() -> [Tourney] {
        realm = try! Realm()
        let tourneys = realm?.objects(TourneyRealm.self)
        
        return tourneys?.elements.map({ tRealm -> Tourney in
            return tRealm.toTourney()
        }) ?? []
    }
    
    func setLocalTourneys(newTourneys: [Tourney]) {
        deleteLocalTourneys()
        
        realm = try! Realm()
        
        try! realm?.write {
            let tourneys = newTourneys.map { $0.toTourneyRealm() }
            realm?.add(tourneys)
        }
    }
    
    func appendTourney(_ tourney: Tourney) {
        removeTourney(tourney)

        var tourneys = getLocalTourneys()
                
        tourneys.append(tourney)
        
        setLocalTourneys(newTourneys: tourneys)
    }
    
    func removeTourney(_ tourney: Tourney) {
        var tourneys = getLocalTourneys()
        
        tourneys.removeAll(where: { tourneyForRemove -> Bool in
            return tourneyForRemove.id == tourney.id
        })
        
        setLocalTourneys(newTourneys: tourneys)
        
    }
    
    func deleteLocalTourneys() {
        realm = try! Realm()
        let tourneys = realm?.objects(TourneyRealm.self)
        
        try! realm?.write {
            realm?.delete(tourneys!)
        }
    }
    
}
