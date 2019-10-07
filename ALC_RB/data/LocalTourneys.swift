//
//  LocalTourneys.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 07/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class LocalTourneys {
    
    let userKey = "localTourneys"
    let userDefaults = UserDefaults.standard
    
    func getLocalTourneyIds() -> [Tourney] {
        do {
            let tourneyIds = try self.userDefaults.get(objectType: [Tourney].self, forKey: userKey)
            return tourneyIds ?? []
        } catch {
            print("Some error with getting tourney from UserDefaults")
        }
        return []
    }
    
    func setLocalTourneyIds(tourneyIds: [Tourney]) {
        do {
            try userDefaults.set(object: tourneyIds, forKey: userKey)
        } catch {
            print("Somer error with setting tourney in UserDefaults")
        }
    }
    
    func deleteLocalTourneys() {
        userDefaults.removeObject(forKey: userKey)
    }
    
}
