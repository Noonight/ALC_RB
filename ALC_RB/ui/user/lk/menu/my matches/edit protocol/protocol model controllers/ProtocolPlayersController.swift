//
//  ProtocolPlayers.swift
//  ALC_RB
//
//  Created by ayur on 05.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolPlayersController {
    var players: [LIPlayer] = []
    var playersSwitch: [String : Bool] = [ : ]
    
    init(players: [LIPlayer]) {
        self.players = players
        for i in 0..<players.count {
            playersSwitch = [players[i].playerId : true]
        }
    }
    
    init(players: [LIPlayer], playersSwitch: [String : Bool]) {
        self.players = players
        self.playersSwitch = playersSwitch
    }
    
    func setPlayerValue(playerId: String, value: Bool) {
        self.playersSwitch.updateValue(value, forKey: playerId)
    }
    
    func getValueByKey(playerId: String) -> Bool? {
        return playersSwitch.filter({ (key, value) -> Bool in
            return key == key
        }).first?.value
    }
    
    func getPlayersIdForRequest() -> [String] {
        var resultArray: [String] = []
        for item in players
        {
            if playersSwitch.contains(where: { (key, value) -> Bool in
                return key == item.playerId && value
            }) {
                resultArray.append((playersSwitch.filter { (key, value) -> Bool in
                    return key == item.playerId && value
                    }.first?.key)!)
            }
        }
        return resultArray
    }
}
