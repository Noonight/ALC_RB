//
//  ProtocolPlayers.swift
//  ALC_RB
//
//  Created by ayur on 05.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolPlayersController {
    
    struct PlayersSwitch {
        var key: String
        var value: Bool
        mutating func setValue(value: Bool) {
            self.value = value
        }
    }
    
    var players: [LIPlayer] = []
    var playersSwitch: [PlayersSwitch] = []
    
    init(players: [LIPlayer]) {
        self.players = players
        for i in 0..<players.count {
            playersSwitch.append(PlayersSwitch(key: players[i].playerId, value: true))
        }
    }
    
    init() {
        self.players = []
        self.playersSwitch = []
    }
    
    init(players: [LIPlayer], playersSwitch: [PlayersSwitch]) {
        self.players = players
        self.playersSwitch = playersSwitch
    }
    
    func setPlayerValue(playerId: String, value: Bool) {
//        self.playersSwitch.updateValue(value, forKey: playerId)
//        var switcher = self.playersSwitch.filter { playersSwitch -> Bool in
//            return playersSwitch.playersSwitch.filter({ (key, value) -> Bool in
//                return key == playerId
//            }).first?.key == playerId
//        }.first
//        switcher?.setValue(key: playerId, value: value)
//        self.playersSwitch.filter { (switcher) -> Bool in
//            return switcher.key == playerId
//        }
        for i in 0..<playersSwitch.count {
            if self.playersSwitch[i].key == playerId {
                self.playersSwitch[i].value = value
            }
        }
    }
    
    func getValueByKey(playerId: String) -> Bool? {
//        return playersSwitch.filter({ (key, value) -> Bool in
//            return key == key
//        }).first?.value
//        return self.playersSwitch.filter { playersSwitch -> Bool in
//            return playersSwitch.playersSwitch.filter({ (key, value) -> Bool in
//                return key == playerId
//            }).first?.key == playerId
//            }.first?.playersSwitch.filter({ (key, value) -> Bool in
//                return key == playerId
//            }).first?.value
        return self.playersSwitch.filter({ switcher -> Bool in
            return switcher.key == playerId
        }).first?.value
    }
    
    func getPlayersIdForRequest() -> [String] {
        var resultArray: [String] = []
        for item in players
        {
//            if playersSwitch.contains(where: { (key, value) -> Bool in
//                return key == item.playerId && value
//            }) {
//                resultArray.append((playersSwitch.filter { (key, value) -> Bool in
//                    return key == item.playerId && value
//                    }.first?.key)!)
//            }
            if self.playersSwitch.contains(where: { switcher -> Bool in
                return switcher.key == item.playerId && switcher.value
            }) {
                resultArray.append((playersSwitch.filter({ switcher -> Bool in
                    return switcher.key == item.playerId && switcher.value
                }).first?.key)!)
            }
        }
        
        return resultArray
    }
    
    func setSwitcherValues(playersSwitch: [PlayersSwitch]) {
        self.playersSwitch = playersSwitch
    }
}
