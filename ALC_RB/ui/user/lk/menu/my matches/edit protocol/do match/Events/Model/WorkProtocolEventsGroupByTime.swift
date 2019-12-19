//
//  WorkProtocolEventsGroupByTime.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct WorkProtocolEventsGroupByTime {
    
    var title: String
    var events: [WorkProtocolEventModelItem]
    
    init(title: String, events: [WorkProtocolEventModelItem]) {
        self.title = title
        self.events = events
    }
}
