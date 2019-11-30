//
//  MenuGroupModel.swift
//  ALC_RB
//
//  Created by ayur on 29.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct MenuGroupModel {
    
    var title: String
    
    var items: [UserMenuOption]
    
    init(title: String, items: [UserMenuOption]) {
        self.title = title
        self.items = items
    }
    
}
