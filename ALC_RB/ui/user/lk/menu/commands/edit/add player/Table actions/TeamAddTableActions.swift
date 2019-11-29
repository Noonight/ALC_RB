//
//  TeamAddTableActions.swift
//  ALC_RB
//
//  Created by ayur on 29.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol TeamAddTableActions: TableActions {
    
    func onCellSelected(model: CellModel, closure: @escaping (TeamAddPlayerCell.AddPlayerStatus) -> ())
    
}

