//
//  TourneyModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class TourneyModelItem {
    private var item: Tourney
    
    var isSelected = false
    var name: String {
        return item.name
    }
    
    init(item: Tourney) {
        self.item = item
    }
    
}

extension TourneyModelItem: CellModel {}
