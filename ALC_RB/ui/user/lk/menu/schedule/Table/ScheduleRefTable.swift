//
//  ScheduleRefTable.swift
//  ALC_RB
//
//  Created by ayur on 02.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class ScheduleRefTable: NSObject {
    
    var dataSource = [ScheduleGroupByLeagueMatches]()
    
    var tableActions: TableActions
    
    init(tableActions: TableActions) {
        self.tableActions = tableActions
    }
}

extension ScheduleRefTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableActions.onCellSelected(model: dataSource[indexPath.section].matches[indexPath.row])
    }
}

extension ScheduleRefTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].matches.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleRefCell.ID, for: indexPath) as! ScheduleRefCell
        
        cell.scheduleMatch = dataSource[indexPath.section].matches[indexPath.row]
        
        return cell
    }
}
