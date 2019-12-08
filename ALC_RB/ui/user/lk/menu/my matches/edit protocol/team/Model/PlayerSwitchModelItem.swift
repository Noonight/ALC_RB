//
//  PlayerSwitchModelItem.swift
//  ALC_RB
//
//  Created by ayur on 08.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class PlayerSwitchModelItem {
    
    let player: PlayerModelItem
    
    var isRight = false
    
    init(player: Player, isRight: Bool = false) {
        self.player = PlayerModelItem(player: player)
        self.isRight = isRight
    }
    
}
