//
//  MenuHelper.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 10/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

class MenuHelper: NSObject, UITableViewDelegate, UITableViewDataSource {
    enum CellIdentifiers {
        static let cellId = "drawer_menu_cell"
    }
    
    var userType: Person.TypeOfPerson?
    var playerMenuOptionActions: ((PlayerMenuOption) -> ())?
    var refereeMenuOptionActions: ((RefereeMenuOption) -> ())?
    var mainRefereeMenuOptionActions: ((MainRefereeMenuOption) -> ())?
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userType == Person.TypeOfPerson.player {
            return 5
        }
        if userType == Person.TypeOfPerson.referee {
            return 2
        }
        if userType == Person.TypeOfPerson.mainReferee {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cellId, for: indexPath) as! DrawerMenuTableViewCell
        
        cell.image_view.image = nil
        cell.image_view.image = #imageLiteral(resourceName: "ic_logo_full")
        
        if userType == Person.TypeOfPerson.player {
            let menuOption = PlayerMenuOption(rawValue: indexPath.row)
            cell.image_view.image = menuOption?.image
            cell.name_label.text = menuOption?.description
        } else if userType == Person.TypeOfPerson.referee {
            let menuOption = RefereeMenuOption(rawValue: indexPath.row)
            cell.image_view.image = menuOption?.image
            cell.name_label.text = menuOption?.description
        } else if userType == Person.TypeOfPerson.mainReferee {
            let menuOption = MainRefereeMenuOption(rawValue: indexPath.row)
            cell.image_view.image = menuOption?.image
            cell.name_label.text = menuOption?.description
        } else {
            cell.name_label.text = "Ошибка в создании меню"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userType == Person.TypeOfPerson.player {
            let menuOption = PlayerMenuOption(rawValue: indexPath.row)
            playerMenuOptionActions!(menuOption!)
        }
        if userType == Person.TypeOfPerson.referee {
            let menuOption = RefereeMenuOption(rawValue: indexPath.row)
            refereeMenuOptionActions!(menuOption!)
        }
        if userType == Person.TypeOfPerson.mainReferee {
            let menuOption = MainRefereeMenuOption(rawValue: indexPath.row)
            mainRefereeMenuOptionActions!(menuOption!)
        }
//        let menuOption = PlayerMenuOption(rawValue: indexPath.row)
//        didSelectMenuOption(menuOption: menuOption!)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
