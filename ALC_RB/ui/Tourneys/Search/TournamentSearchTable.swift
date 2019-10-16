//
//  TournamentSearchTable.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 04/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TournamentSearchTable: NSObject {
    
    let cellNib = UINib(nibName: "TournamentSearchTableViewCell", bundle: Bundle.main)
    
    var dataSource: [SearchTourneyModelItem] = []
    
    var actions: CellActions?
    
    init(actions: CellActions) {
        self.actions = actions
    }
    
    @objc func tapOnCell(index: IndexPath) {
        
    }
    
}

extension TournamentSearchTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = dataSource[indexPath.row]
        cell.isSelected = true
        self.actions?.onCellSelected(model: cell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = dataSource[indexPath.row]
        cell.isSelected = false
        self.actions?.onCellDeselected(model: cell)
    }
}

extension TournamentSearchTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TournamentSearchTableViewCell.ID, for: indexPath) as! TournamentSearchTableViewCell
        
        cell.tourneyModelItem = dataSource[indexPath.row]
        if dataSource[indexPath.row].isSelected
        {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
}
