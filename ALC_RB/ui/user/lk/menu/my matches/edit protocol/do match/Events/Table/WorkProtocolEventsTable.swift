//
//  WorkProtocolEventsTable.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class WorkProtocolEventsTable: NSObject {
    
    let tableActions: TableActions
    var dataSource = [WorkProtocolEventsGroupByTime]()
    
    init(tableActions: TableActions) {
        self.tableActions = tableActions
    }
    
}

extension WorkProtocolEventsTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.showAccessoryLoading()
        
        tableActions.onCellSelected(model: dataSource[indexPath.section].events[indexPath.row])
    }
}

extension WorkProtocolEventsTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkProtocolEventsCell.ID, for: indexPath) as! WorkProtocolEventsCell
        
        // init cell model
        
        return cell
    }


}
