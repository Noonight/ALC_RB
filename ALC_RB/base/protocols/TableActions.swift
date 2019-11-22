//
//  CellActions.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol TableActions {
    func onCellSelected(model: CellModel)
    func onCellSelected(models: [CellModel])
    
    func onCellSelected(model: CellModel, closure: @escaping () -> ())
    
    func onCellDeselected(model: CellModel)
    
    func onCellDelete(indexPath: IndexPath, model: CellModel)
    
    func onHeaderPressed(model: CellModel)
    func onHeaderPressed(models: [CellModel])
    
    func onHeaderDeletePressed(model: CellModel)
}
extension TableActions {
    func onCellSelected(model: CellModel) {}
    func onCellSelected(models: [CellModel]) {}
    
    func onCellSelected(model: CellModel, closure: @escaping () -> ()) { }
    
    func onCellDeselected(model: CellModel) {}
    
    func onCellDelete(indexPath: IndexPath, model: CellModel) {}
    
    func onHeaderPressed(model: CellModel) {}
    func onHeaderPressed(models: [CellModel]) {}
    
    func onHeaderDeletePressed(model: CellModel) {}
}

protocol CellModel { }
