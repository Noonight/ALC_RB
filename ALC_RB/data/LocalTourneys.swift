//
//  LocalTourneys.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 07/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class LocalTourneys {
    
    let userKey = "local_tourneys"
    let userDefaults = UserDefaults.standard
    
    func getLocalTourneys() -> [Tourney] {
        do {
//            let tourneyData = try self.userDefaults.get(objectType: Data.self, forKey: userKey)
//            if let tourneys = tourneyData {
//                if let tourneysArray = NSKeyedUnarchiver.unarchiveObject(with: tourneys) as? [Tourney] {
//                    return tourneysArray
//                }
//            }
            let tourneys = try self.userDefaults.get(objectType: [Tourney].self, forKey: userKey)
//            Print.m(tourneys)
            return tourneys ?? []
        } catch {
            Print.m("Some error with getting tourney from UserDefaults")
        }
        return []
    }
    
    func setLocalTourneys(newTourneys: [Tourney]) {
        do {
//            let tourneysData = NSKeyedArchiver.archivedData(withRootObject: newTourneys)
            try userDefaults.set(object: newTourneys, forKey: userKey)
        } catch {
            Print.m("Somer error with setting tourney in UserDefaults")
        }
    }
    
    func appendTourney(_ tourney: Tourney) {
        removeTourney(tourney)

        var tourneys = getLocalTourneys()
                
        tourneys.append(tourney)
//        Print.m(tourneys)
        setLocalTourneys(newTourneys: tourneys)
        
        
//        var isAppended = tourneys?.contains(where: { item -> Bool in
//            return item.id == tourney.id
//        })
//
//        if isAppended == false
//        {
//            tourneys?.append(tourney)
//            if let mTourneys = tourneys {
//                setLocalTourneys(newTourneys: mTourneys)
//            }
//        }
    }
    
    func removeTourney(_ tourney: Tourney) {
        var tourneys = getLocalTourneys()
        
        tourneys.removeAll(where: { tourneyForRemove -> Bool in
            return tourneyForRemove.id == tourney.id
        })
        
        setLocalTourneys(newTourneys: tourneys)
        
    }
    
    func deleteLocalTourneys() {
        userDefaults.removeObject(forKey: userKey)
    }
    
}

// MARK: HELPERS

extension LocalTourneys {
//    func helperUpdateItems(items: [TourneyModelItem]) {
//
//        var tourneys = getLocalTourneys()
//
//        var forRemove: [Tourney] = []
//        var forAppend: [Tourney] = []
//
//        for i in 0..<tourneys?.count
//        {
//            for j in 0..<items.count
//            {
//                if tourneys[i].id == items[j].getTourney().id && items[j].isSelected == false
//                {
//                    forRemove.append(tourneys[i])
//                }
//            }
//
//        }
//
//        var setItems = Set(items.map { tourney -> String in
//            return tourney.getTourney().id ?? ""
//        })
//        setItems.subtract(tourneys.map({ tourney -> String in
//            return tourney.id ?? ""
//        }))
//
//        for i in setItems
//        {
//            for j in 0...items.count - 1
//            {
//                if i == items[j].getTourney().id
//                {
//                    forAppend.append(items[j].getTourney())
//                }
//            }
//        }
//
//        tourneys.removeAll { tourney -> Bool in
//            return forRemove.contains(where: { forTourney -> Bool in
//                return forTourney.id == tourney.id
//            })
//        }
//        tourneys.append(contentsOf: forAppend)
//
//        setLocalTourney(newTourneys: tourneys)
//    }
}
