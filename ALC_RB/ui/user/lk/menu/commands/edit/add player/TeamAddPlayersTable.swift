//
//  TeamAddPlayersTable.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamAddPlayersTable: NSObject {
    
    var dataSource: [TeamAddPlayerModelItem] = []
    
    var tableActions: TableActions?
    
    init(tableActions: TableActions) {
        self.tableActions = tableActions
    }
    
}

extension TeamAddPlayersTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var cell: TeamAddPlayerCell?
        if dataSource[indexPath.row].status == nil {
            cell = tableView.cellForRow(at: indexPath) as! TeamAddPlayerCell
            cell?.showLoading()
        }
        tableActions?.onCellSelected(model: dataSource[indexPath.row], closure: {
            cell?.teamAddPlayer.status = .pending
            cell?.showAdd()
        })
    }
}

extension TeamAddPlayersTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamAddPlayerCell.ID, for: indexPath) as! TeamAddPlayerCell
        
        cell.teamAddPlayer = dataSource[indexPath.row]
        
        return cell
    }
    
    
}
