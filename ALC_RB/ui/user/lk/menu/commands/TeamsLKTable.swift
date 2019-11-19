//
//  TeamsLKTable.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamsLKTable: NSObject {
    
    var dataSource = [TeamGropModelItem]()
    let actions: TableActions
    
    init(dataSource: [TeamGropModelItem], tableActions: TableActions) {
        self.dataSource = dataSource
        self.actions = tableActions
    }
    
}

extension TeamsLKTable: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            actions.onCellSelected(model: dataSource[indexPath.section].items[indexPath.row])
        }
        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//
//                if indexPath.section == 0 {
//                    showRemoveTeamAlert(teamName: tableModel.ownerTeams[indexPath.row].name!, delete: {
//                        self.tableModel.ownerTeams.remove(at: indexPath.row)
//                        tableView.deleteRows(at: [indexPath], with: .left)
//                        // TODO: do api request to delete team
//                    }) {
//                        Print.m("cancel team delete")
//                    }
//    //                Print.m("delete cell at \(indexPath.row) -> \(tableModel.ownerTeams[indexPath.row])")
//                }
//                if indexPath.section == 1 {
//                    showRemoveTeamAlert(teamName: tableModel.playerTeams[indexPath.row].name!, delete: {
//                        self.tableModel.playerTeams.remove(at: indexPath.row)
//                        tableView.deleteRows(at: [indexPath], with: .left)
//                    }) {
//                        Print.m("cancel team delete")
//                    }
//
//    //                Print.m("delete cell at \(indexPath.row) -> \(tableModel.fplayerTeams[indexPath.row])")
//                }
//
//            }
//        }
//
}

extension TeamsLKTable: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamLKTableViewCell.ID, for: indexPath) as! TeamLKTableViewCell
        
        cell.teamModelItem = dataSource[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    
    
    
}
