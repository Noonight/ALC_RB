//
//  DrawerMenuTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class DrawerMenuTableViewCell: UITableViewCell {
    
    static let ID = "drawer_menu_cell"
    
    @IBOutlet weak var image_view: UIImageView!
    @IBOutlet weak var name_label: UILabel!

    var menuOption: UserMenuOption! {
        didSet {
            self.image_view.image = menuOption.image
            self.name_label.text = menuOption.description
        }
    }
    
}
