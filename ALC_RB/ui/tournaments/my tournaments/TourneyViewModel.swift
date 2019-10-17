//
//  TourneyViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 07/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TourneyViewModel {
    
    var table: TournamentsTable?
    var tourneyMIs: [TourneyModelItem] = []
    
    func setupTable(to tableView: UITableView) {
        self.table = TournamentsTable(actions: self)
        tableView.delegate = self.table
        tableView.dataSource = self.table
    }
    
    
    
}

extension TourneyViewModel: TableActions {
    func onCellDeselected(model: CellModel) {
        
    }
    
    func onCellSelected(model: CellModel) {
        switch model {
        case is TourneyModelItem:
            print("do some staff")
        default:
            break
        }
    }
}
