//
//  CommandInvitePlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol OnCommandInvitePlayerDeleteBtnPressedProtocol {
    func onDeleteInvBtnPressed(index: IndexPath, model: CommandInvitePlayersTableViewCell.CellModel, success: @escaping () -> ())
}

class CommandInvitePlayersTableViewHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "command_invite_players_cell"
    
    private var deleteBtnProtocol: OnCommandInvitePlayerDeleteBtnPressedProtocol?
    
    private var tableData: [CommandInvitePlayersTableViewCell.CellModel] = []
    
    func setTableData(tableData: [CommandInvitePlayersTableViewCell.CellModel]) {
        self.tableData = tableData
    }
    
    func setDeleteBtnProtocol(deleteBtnDelegate: OnCommandInvitePlayerDeleteBtnPressedProtocol) {
        self.deleteBtnProtocol = deleteBtnDelegate
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func configureCell(cell: CommandInvitePlayersTableViewCell, model: CommandInvitePlayersTableViewCell.CellModel, tag: Int) {
        cell.cellModel = model
//        cell.playerDeleteBtn.tag = tag
        
        cell.cellModel?.number = model.number
        
//        cell.playerCommandNum.text = String(tag + 1)
        
//        cell.playerDeleteBtn.addTarget(self, action: #selector(deleteBtnPressed(_:)), for: .touchUpInside)
    }
    
//    @objc func deleteBtnPressed(_ sender: UIButton) {
////        Print.m("tag: \(sender.tag) delete pressed")
//        deleteBtnProtocol?.onDeleteInvBtnPressed(index: )
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteBtnProtocol?.onDeleteInvBtnPressed(index: indexPath, model: tableData[indexPath.row]) {
                self.tableData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
