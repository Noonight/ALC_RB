//
//  MainTabBarViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 23/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

//    private lazy var homeVC: HomeViewController = {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        var viewController = storyboard.instantiateViewController(withIdentifier: "UpcomingGamesTableViewController") as! UpcomingGamesTableViewController
//
//        //self.add(childVC: viewController)
//
//        return viewController
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabBar()
    }
    
    func setupTabBar() {
        let homeVC = self.createNavController(rootViewController: HomeViewController.storyboardInstance(), image: #imageLiteral(resourceName: "tab_home"))
        let tournamentVC = self.createNavController(rootViewController: TournamentsTableViewController.storyboardInstance(), image: #imageLiteral(resourceName: "tab_cup"))
        let clubsVC = self.createNavController(rootViewController: ClubsTableViewController.storyboardInstance(), image: #imageLiteral(resourceName: "tab_club"))
        let playersVC = self.createNavController(rootViewController: PlayersTableViewController.storyboardInstance(), image: #imageLiteral(resourceName: "tab_players"))
        let lkVC  = self.createNavController(rootViewController: AuthViewController.storyboardInstance(), image: #imageLiteral(resourceName: "tab_user"))
        
        viewControllers = [homeVC, tournamentVC, clubsVC, playersVC, lkVC]
        
        guard let items = self.tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5.5, left: 0, bottom: -5.5, right: 0)
        }
    }
    
}

extension MainTabBarViewController {
    
    func createNavController(rootViewController: UIViewController, image: UIImage) -> UINavigationController {
        let viewController = UINavigationController(rootViewController: rootViewController)
        viewController.tabBarItem.image = image
        return viewController
    }
}

extension UIViewController {
    fileprivate static func storyboardInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
}
