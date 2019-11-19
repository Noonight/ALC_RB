//
//  CommandModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamModelItem {
    
    var team: Team!
    
    init(team: Team) {
        self.team = team
    }
    
    var name: String? {
        return team.name
    }
    
    var creatorName: String? {
        return team.creator?.getValue()?.name
    }
    
    var
    
}
