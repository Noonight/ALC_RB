//
//  WorkProtocolEventModelItem.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension WorkProtocolEventModelItem: CellModel {}

struct WorkProtocolEventModelItem {
    
    let event: Event
    let team: TeamEnum
    
    init(event: Event, team: TeamEnum) {
        self.event = event
        self.team = team
    }
    
    var creatorName: String? {
        return event.player?.getValue()?.getSurnameNP() ?? event.team?.getValue()?.name
    }
    
    var typeImage: UIImage {
        return event.type!.getImage()
    }
}
