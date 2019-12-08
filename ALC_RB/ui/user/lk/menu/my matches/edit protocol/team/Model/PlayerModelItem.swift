//
//  PlayerModelItem.swift
//  ALC_RB
//
//  Created by ayur on 08.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class PlayerModelItem {
    
    let player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    var number: Int? {
        return player.number
    }
    
    var activeYellowCards: Int? {
        return player.activeYellowCards
    }
    
    var activeDisquals: Int? {
        return player.activeDisquals
    }
    
    var personName: String? {
        return player.person?.getValue()?.name
    }
    
}
