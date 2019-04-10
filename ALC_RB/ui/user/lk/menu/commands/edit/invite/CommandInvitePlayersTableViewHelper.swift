//
//  CommandInvitePlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class CommandInvitePlayersTableViewHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "command_invite_players_cell"
    
    private var tableData: [CommandInvitePlayersTableViewCell.CellModel] = []
    
    func setTableData(tableData: [CommandInvitePlayersTableViewCell.CellModel]) {
        self.tableData = tableData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandInvitePlayersTableViewCell
        let model = tableData[indexPath.row]
        
        configureCell(cell: cell, model: model, tag: indexPath.row)
        
        return cell
    }
    
    func configureCell(cell: CommandInvitePlayersTableViewCell, model: CommandInvitePlayersTableViewCell.CellModel, tag: Int) {
        cell.cellModel = model
        cell.playerDeleteBtn.tag = tag
        
        cell.playerDeleteBtn.addTarget(self, action: #selector(deleteBtnPressed(_:)), for: .touchUpInside)
    }
    
    @objc func deleteBtnPressed(_ sender: UIButton) {
        Print.m("tag: \(sender.tag) delete pressed")
    }
}
