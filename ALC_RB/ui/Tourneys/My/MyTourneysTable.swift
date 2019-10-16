//
//  MyTourneysTable.swift
//  ALC_RB
//
//  Created by ayur on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class MyTourneysTable: NSObject {
    
    let cellNib = UINib(nibName: "MyTourneyCell", bundle: Bundle.main)
    
    var dataSource: [TourneyModelItem] = []
    let cellActions: CellActions
    
    init(cellActions: CellActions) {
        self.cellActions = cellActions
    }
    
}

extension MyTourneysTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellActions.onCellSelected(model: dataSource[indexPath.section].leagues![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MyTourneysTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].leagues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTourneyCell.ID, for: indexPath) as! MyTourneyCell
        
        cell.leagueModelItem = dataSource[indexPath.section].leagues?[indexPath.row]
        
        return cell
    }
}
