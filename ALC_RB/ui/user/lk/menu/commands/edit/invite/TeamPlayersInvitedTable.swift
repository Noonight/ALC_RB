//
//  CommandInvitePlayersTableViewHelper.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol TeamPlayerInvitedDeleteProtocol {
    func onDeleteInvBtnPressed(index: IndexPath, model: TeamPlayerInviteStatus, success: @escaping () -> ())
}

class TeamPlayersInvitedTable: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "command_invite_players_cell"
    
    var deleteBtnProtocol: TeamPlayerInvitedDeleteProtocol?
    
    var dataSource: [TeamPlayerInviteStatus] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommandInvitePlayersTableViewCell
        
        cell.playerInviteStatus = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteBtnProtocol?.onDeleteInvBtnPressed(index: indexPath, model: dataSource[indexPath.row]) {
                self.dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
