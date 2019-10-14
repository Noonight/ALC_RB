//
//  AnnounceModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 14.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class AnnounceModelItem {
    
    let announce: Announce
    var tourney: Tourney?
    
    init(newAnnounce: Announce, tourney: Tourney?) {
        self.announce = newAnnounce
        self.tourney = tourney
    }
    
    var content: String? {
        return announce.content
    }
    var date: String? {
        return announce.updatedAt?.toFormat(DateFormats.local.rawValue)
    }
    
}
