//
//  UserViewController.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var drawerMenuView: UIView!
    @IBOutlet weak var headerMenuView: UIView!
    @IBOutlet weak var userHeaderMenuImage: UIImageView!
    @IBOutlet weak var userHeaderMenuLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var drawerLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var containerView: UIView!
    
    let cellId = "drawer_menu_cell"
    
    var drawerIsOpened = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        containerView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        setDrawerState()
    }
    
    func setDrawerState() {
        if drawerIsOpened {
            drawerLeadingConstraint.constant = -220
        } else {
            self.drawerMenuView.layer.shadowOpacity = 0.5
            self.drawerMenuView.layer.shadowRadius = 5
            drawerLeadingConstraint.constant = 0
        }
    
        UIView.animate(withDuration: 0.5, animations: {
            if self.drawerIsOpened {
                self.containerView.alpha = 0
            } else {
                self.containerView.alpha = 1
            }
            self.view.layoutIfNeeded()
        }) { (completed) in
            if self.drawerIsOpened {
                self.drawerMenuView.layer.shadowOpacity = 0.5
                self.drawerMenuView.layer.shadowRadius = 5
            } else {
                self.drawerMenuView.layer.shadowOpacity = 0
                self.drawerMenuView.layer.shadowRadius = 0
            }
        }

        drawerIsOpened = !drawerIsOpened
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Invites:
            print(menuOption.rawValue)
        case .Tournaments:
            print(menuOption.rawValue)
        case .Clubs:
            print(menuOption.rawValue)
        case .Teams:
            print(menuOption.rawValue)
        case .SignOut:
            print(menuOption.rawValue)
        }
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DrawerMenuTableViewCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.image_view.image = menuOption?.image
        cell.name_label.text = menuOption?.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        didSelectMenuOption(menuOption: menuOption!)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
