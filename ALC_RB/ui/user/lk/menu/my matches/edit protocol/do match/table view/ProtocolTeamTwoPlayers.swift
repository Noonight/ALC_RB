//
//  ProtocolTeamTwoPlayers.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ProtocolTeamTwoPlayers : NSObject {
    enum Cell {
        static let CELL = "cell_protocol_team_two"
    }
    
    var cellActions: CellActions?
    var dataSource: [RefereeProtocolPlayerTeamCellModel] = []
    
    init(dataSource: [RefereeProtocolPlayerTeamCellModel], cellActions: CellActions) {
        self.dataSource = dataSource
        self.cellActions = cellActions
    }
}

extension ProtocolTeamTwoPlayers : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // row selected do somethig  # important place
        self.cellActions?.onCellSelected(model: self.dataSource[indexPath.row]) // call back here <---
    }
}

extension ProtocolTeamTwoPlayers : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.CELL, for: indexPath) as! RefereeProtocolPlayerTeamTwoTableViewCell
        
        cell.configure(cellModel: dataSource[indexPath.row])
        
        return cell
    }
}
