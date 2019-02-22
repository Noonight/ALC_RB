//
//  UserViewController.swift
//  ALC_RB
//
//  Created by user on 29.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UserLKViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var drawerMenuView: UIView!
    @IBOutlet weak var headerMenuView: UIView!
    @IBOutlet weak var userHeaderMenuImage: UIImageView!
    @IBOutlet weak var userHeaderMenuLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawerShadowButton: UIButton!
    
    @IBOutlet weak var drawerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    
    let cellId = "drawer_menu_cell"
    
    var drawerIsOpened = false
    
    var segmentHelper: SegmentHelper?
    
    // MARK: - Drawer controllers
    
    private lazy var newsTable: NewsAnnounceTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsTableViewController") as! NewsAnnounceTableViewController
        
        return viewController
    }()
    
    private lazy var tournaments: TournamentsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "TournamentsTableViewController") as! TournamentsTableViewController
        
        return viewController
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentHelper = SegmentHelper(self, containerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showFirstItem()
    }
    
    // MARK: - Drawer btn action
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        setDrawerState()
    }

    @IBAction func shadowBtnPressed(_ sender: UIButton) {
        setDrawerState()
    }
    
    // MARK: - Drawer menu
    
    func showFirstItem() {
        segmentHelper?.add(newsTable)
        tableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.top)
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
                self.drawerShadowButton.alpha = 0
            } else {
                self.drawerShadowButton.alpha = 0.5
                self.drawerShadowButton.isHidden = false
            }
            self.view.layoutIfNeeded()
        }) { (completed) in
            if self.drawerIsOpened {
                self.drawerMenuView.layer.shadowOpacity = 0
                self.drawerMenuView.layer.shadowRadius = 0
                self.drawerShadowButton.isHidden = true
            } else {
                self.drawerMenuView.layer.shadowOpacity = 0.5
                self.drawerMenuView.layer.shadowRadius = 5
                self.drawerShadowButton.isHidden = false
            }
            self.drawerIsOpened = !self.drawerIsOpened
        }
    }

    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Invites:
            segmentHelper?.remove(tournaments)
            segmentHelper?.add(newsTable)
            print(menuOption.rawValue)
        case .Tournaments:
            segmentHelper?.remove(newsTable)
            segmentHelper?.add(tournaments)
            print(menuOption.rawValue)
        case .Clubs:
            print(menuOption.rawValue)
        case .Teams:
            print(menuOption.rawValue)
        case .SignOut:
            print(menuOption.rawValue)
        }
        setDrawerState()
    }
}

extension UserLKViewController: UITableViewDelegate, UITableViewDataSource {
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