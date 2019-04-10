//
//  CommandPlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol OnCommandPlayerDeleteBtnPressedProtocol {
    func onDeleteBtnPressed(sender: UIButton)
}

class CommandPlayersTableViewHelper: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "command_player_cell"
//    var actionOnDelete =
    
    private var deleteBtnProtocol: OnCommandPlayerDeleteBtnPressedProtocol?
    
    private var tableData: [CommandPlayersTableViewCell.CellModel] = []
    
    func setDeleteBtnProtocol(deleteBtnDelegate: OnCommandPlayerDeleteBtnPressedProtocol) {
        self.deleteBtnProtocol = deleteBtnDelegate
    }
    
    func setTableData(tableData: [CommandPlayersTableViewCell.CellModel]) {
        self.tableData = tableData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandPlayersTableViewCell
        let model = tableData[indexPath.row]
        
        configureCell(cell: cell, model: model, tag: indexPath.row)
        
        return cell
    }
    
    func configureCell(cell: CommandPlayersTableViewCell, model: CommandPlayersTableViewCell.CellModel, tag: Int) {
        cell.cellModel = model
        cell.playerDeleteBtn.tag = tag
        
        cell.playerCommandNumLabel.text = String(tag + 1)
        
        cell.playerDeleteBtn.addTarget(self, action: #selector(deleteBtnPressed(_:)), for: .touchUpInside)
    }
    
    @objc func deleteBtnPressed(_ sender: UIButton) {
        Print.m("tag: \(sender.tag) delete pressed")
        deleteBtnProtocol?.onDeleteBtnPressed(sender: sender)
    }
}
