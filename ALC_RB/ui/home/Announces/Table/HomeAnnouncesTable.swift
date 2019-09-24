//
//  HomeAnnouncesTable.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension AnnounceElement : CellModel {}

final class HomeAnnouncesTable: NSObject {
    
    let cellNib = UINib(nibName: "HomeAnonunceTableViewCell", bundle: Bundle.main)
    
    var dataSource: [AnnounceElement] = []
    var actions: CellActions?
    
    init(actions: CellActions) {
        self.actions = actions
    }
    
}

extension HomeAnnouncesTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if actions != nil
        {
            self.actions?.onCellSelected(model: dataSource[indexPath.row])
        }
    }
}

extension HomeAnnouncesTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeAnonunceTableViewCell.ID, for: indexPath) as! HomeAnonunceTableViewCell
        
        cell.configure(dataSource[indexPath.row ])
        
        return cell
    }
    
}
