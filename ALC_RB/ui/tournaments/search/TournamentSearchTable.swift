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
    
    var dataSource: [MmMatch] = []
    
    var actions: CellActions?
    
    init(actions: CellActions) {
        self.actions = actions
    }
    
}

extension TournamentSearchTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if actions != nil
        {
            self.actions?.onCellSelected(model: dataSource[indexPath.row])
        }
    }
}

extension TournamentSearchTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TournamentSearchTableViewCell.ID, for: indexPath) as! TournamentSearchTableViewCell
        
        
        
        return cell
    }
    
}
