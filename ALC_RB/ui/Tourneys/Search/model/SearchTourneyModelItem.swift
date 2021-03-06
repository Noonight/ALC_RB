//
//  TourneyModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 06/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class SearchTourneyModelItem {
    private var item: Tourney
    
    var isSelected = false
    var name: String? {
        return item.name
    }
    var beginDate: Date? {
        return item.beginDate
    }
    var endDate: Date? {
        return item.endDate
    }
    var countOfTeams: Int? {
        return item.maxTeams
    }
    
    // for local storage
    func getTourney() -> Tourney {
        return self.item
    }
    
    init(item: Tourney) {
        self.item = item
    }
    
}

extension SearchTourneyModelItem: CellModel {}
