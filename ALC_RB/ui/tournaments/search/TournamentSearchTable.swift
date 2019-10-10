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
    
    var dataSource: [TourneyModelItem?] = []
    
    var actions: CellActions?
    
    init(actions: CellActions) {
        self.actions = actions
    }
    
}

extension TournamentSearchTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actions?.onCellSelected(model: dataSource[indexPath.row]!)
//        self.dataSource[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.actions?.onCellDeselected(model: dataSource[indexPath.row]!)
//        self.dataSource[indexPath.row].isSelected = false
    }
}

extension TournamentSearchTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is TournamentSearchTableViewCell
        {
            let mCell = cell as! TournamentSearchTableViewCell
            if mCell.tag == tableView.indexPath(for: cell)?.row
            {
                mCell.type_view.type = self.dataSource[indexPath.row]?.isSelected ?? false ? .checkmark : .none
            }
//            mCell.type_view.type = self.dataSource[indexPath.row]?.isSelected ?? false ? .checkmark : .none
//            mCell.type_view.type = mCell.isSelected ? .checkmark : .none
        }
        (cell as! TournamentSearchTableViewCell).type_view.image_view.isHidden = false
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is TournamentSearchTableViewCell
        {
            let mCell = cell as! TournamentSearchTableViewCell
//            mCell.type_view.type = self.dataSource[indexPath.row]?.isSelected ?? false ? .checkmark : .none
            //            mCell.type_view.type = mCell.isSelected ? .checkmark : .none
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TournamentSearchTableViewCell.ID, for: indexPath) as! TournamentSearchTableViewCell
        
//        if self.dataSource.count - 1 >= 0
//        {
//            cell.tourneyModelItem = self.dataSource[indexPath.row]
////            Print.m("cell is selected \(dataSource[indexPath.row].isSelected)")
////            cell.accessoryType = self.dataSource[indexPath.row].isSelected ? .checkmark : .none
//            dataSource[indexPath.row].isSelected ? tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) : tableView.deselectRow(at: indexPath, animated: false)
//        }
        
        if let item = dataSource[indexPath.row]
        {
            cell.tourneyModelItem = item
            cell.date_label.text = String(indexPath.row)
            cell.tag = indexPath.row
//            cell.type_view.type = .none
//            cell.type_view.type = item.isSelected ? .checkmark : .none
        }
        
        return cell
    }
    
}
