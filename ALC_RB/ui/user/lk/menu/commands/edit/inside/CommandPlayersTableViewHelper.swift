//
//  CommandPlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class CommandPlayersTableViewHelper: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "command_player_cell"
    
    private var tableData: [CommandPlayersTableViewCell.CellModel] = []
    
    func setTableData(tableData: [CommandPlayersTableViewCell.CellModel]) {
        self.tableData = tableData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandPlayersTableViewCell
        let model = tableData[indexPath.row]
        
        configureCell(cell: cell, model: model)
        
        return cell
    }
    
    func configureCell(cell: CommandPlayersTableViewCell, model: CommandPlayersTableViewCell.CellModel) {
        cell.cellModel = model
    }
}
