//
//  InvitationTableActions.swift
//  ALC_RB
//
//  Created by ayur on 01.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol InvitationTableActions: TableActions {
    
    func onOkPressed(model: InvitationModelItem, closure: @escaping () -> ())
    
    func onCancelPressed(model: InvitationModelItem, closure: @escaping () -> ())
    
}
