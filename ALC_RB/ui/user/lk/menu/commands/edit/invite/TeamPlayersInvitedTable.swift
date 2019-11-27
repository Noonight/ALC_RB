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
    
    var deleteBtnProtocol: TeamPlayerInvitedDeleteProtocol?
    
    var dataSource: [TeamPlayerInviteStatus] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommandInvitePlayersTableViewCell.ID, for: indexPath) as! CommandInvitePlayersTableViewCell
        
        cell.playerInviteStatus = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            cell?.accessoryView = activityIndicator
            
            deleteBtnProtocol?.onDeleteInvBtnPressed(index: indexPath, model: dataSource[indexPath.row]) {
                cell?.accessoryView = nil
                cell?.accessoryType = .none
//                self.dataSource.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
