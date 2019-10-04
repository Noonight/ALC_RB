//
//  TournamentsTable.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class TournamentsTable: NSObject {
    
    var dataSource: [League] = []
    var cellActions: CellActions?
    
    init(actions: CellActions) {
        self.cellActions = actions
    }
}

extension TournamentsTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.cellActions != nil
        {
            self.cellActions?.onCellSelected(model: dataSource[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TournamentsTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TournamentTableViewCell.ID) as! TournamentTableViewCell
        
        cell.configure(league: dataSource[indexPath.row])
        
        return cell
    }
    
    
}
