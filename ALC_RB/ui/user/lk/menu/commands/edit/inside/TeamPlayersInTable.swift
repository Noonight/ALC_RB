//
//  CommandPlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol TeamPlayerDeleteProtocol {
    func onDeleteBtnPressed(index: IndexPath, model: Player, success: @escaping() -> ()) // delete is ok or not
}

protocol TeamPlayerEditProtocol {
    func onEditNumberComplete(model: Player)
}

class TeamPlayersInTable: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "command_player_cell"
    
    var deleteBtnProtocol: TeamPlayerDeleteProtocol?
    
    var editNumberCompleteProtocol: TeamPlayerEditProtocol?
    
    var dataSource: [Player] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandPlayersTableViewCell
        let model = dataSource[indexPath.row]
        
        configureCell(cell: cell, model: model, tag: indexPath.row)
        
        return cell
    }
    
    func configureCell(cell: CommandPlayersTableViewCell, model: Player, tag: Int) {
        cell.playerStatus = model
        cell.playerNumberTextDidEndProtocol = self.editNumberCompleteProtocol!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteBtnProtocol?.onDeleteBtnPressed(index: indexPath, model: dataSource[indexPath.row]) {
                
                if self.dataSource.count == 1 {
                    Print.m("table data = 1")
                } else {
                    self.dataSource.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
