//
//  HomeScheduleTable.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension Match : CellModel {}

final class HomeScheduleTable: NSObject {
    
    let cellNib = UINib(nibName: "HomeScheduleTableViewCell", bundle: Bundle.main)
    
    var dataSource: [Match] = []
    var helperDataSource: [Club] = []
    var actions: TableActions?
    
    init(actions: TableActions) {
        self.actions = actions
    }
    
}

extension HomeScheduleTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.row].played == true {
            if actions != nil
            {
                self.actions?.onCellSelected(model: dataSource[indexPath.row])
            }
        }
    }
}

extension HomeScheduleTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeScheduleTableViewCell.ID, for: indexPath) as! HomeScheduleTableViewCell
        
        cell.configure(dataSource[indexPath.row], clubOne: findClub(id: (dataSource[indexPath.row].teamOne?.club)!), clubTwo: findClub(id: (dataSource[indexPath.row ].teamTwo?.club)!))
        
        return cell
    }
    
}

// MARK: HELP!

extension HomeScheduleTable {
    func findClub(id: String ) -> Club? {
        return self.helperDataSource.filter { club  -> Bool in
            return club.id == id
        }.first
    }
}
