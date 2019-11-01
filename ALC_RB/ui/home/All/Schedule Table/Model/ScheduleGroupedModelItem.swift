//
//  ScheduleModelItem.swift
//  ALC_RB
//
//  Created by mac on 01.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class ScheduleGroupedModelItem {
    
    var date: Date
    var place: String
    var scheduleMatchesModelItems: [ScheduleModelItem]
    
    init(date: Date, place: String, scheduleMatches: [ScheduleModelItem]) {
        self.date = date
        self.place = place
        self.scheduleMatchesModelItems = scheduleMatches
    }
    
}
