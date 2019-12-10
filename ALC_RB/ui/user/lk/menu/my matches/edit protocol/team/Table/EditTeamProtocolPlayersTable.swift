//
//  EditTeamProtocolPlayersTable.swift
//  ALC_RB
//
//  Created by ayur on 08.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class EditTeamProtocolPlayersTable: NSObject {
    
    var dataSource = [PlayerSwitchModelItem]()
    
    let tableActions: EditTeamProtocolPlayersTableActions
    
    init(tableActions: EditTeamProtocolPlayersTableActions) {
        self.tableActions = tableActions
    }
    
}

extension EditTeamProtocolPlayersTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditTeamProtocolCell.ID, for: indexPath) as! EditTeamProtocolCell
        
        cell.switchChangedProtocol = self
        cell.playerSwitchModel = dataSource[indexPath.row]
        
        return cell
    }
}

extension EditTeamProtocolPlayersTable: EditTeamProtocolPlayerSwitchValueChanged {
    func switchValueChanged(model: PlayerSwitchModelItem) {
        for i in 0..<dataSource.count {
            if dataSource[i].player.player.person?.getId() ?? dataSource[i].player.player.person?.getValue()?.id  == model.player.player.person?.getId() ?? model.player.player.person?.getValue()?.id {
                dataSource[i] = model
            }
        }
        self.tableActions.switchValueChanged(model: model)
    }
}
