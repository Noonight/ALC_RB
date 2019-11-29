//
//  MenuHelper.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 10/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class MenuTable: NSObject {
    
    var userMenuOptionActions: ((UserMenuOption) -> ())?
    
    var menu = [MenuGroupModel]()
    
    init(menu: [MenuGroupModel]) {
        self.menu = menu
    }
    
}

extension MenuTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        userMenuOptionActions?(menu[indexPath.section].items[indexPath.row])
    }
    
}

extension MenuTable: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menu[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DrawerMenuTableViewCell.ID, for: indexPath) as! DrawerMenuTableViewCell
        
        cell.menuOption = menu[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
}
