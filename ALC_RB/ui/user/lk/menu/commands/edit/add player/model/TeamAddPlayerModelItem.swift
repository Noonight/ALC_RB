//
//  TeamAddPlayerModelItem.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension TeamAddPlayerModelItem: CellModel {}

class TeamAddPlayerModelItem {
    
    var personModelItem: PersonModelItem
    var status: TeamPlayerInviteStatus.Status?
    
    init(person: Person, status: TeamPlayerInviteStatus.Status? = nil) {
        self.personModelItem = PersonModelItem(person: person)
        self.status = status
    }
    
    var statusRu: String? {
        if status == .pending {
            return "Приглашен"
        }
        if status == .accepted {
            return "В составе"
        }
        return nil
    }
    
}
