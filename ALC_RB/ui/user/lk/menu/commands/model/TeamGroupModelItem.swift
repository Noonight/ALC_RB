//
//  TeamGroupModelItem.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamGropModelItem {
    
    var name: String
    
    var items = [TeamModelItem]()
    
    init(name: String, items: [TeamModelItem]) {
        self.name = name
        self.items = items
    }
    
}
