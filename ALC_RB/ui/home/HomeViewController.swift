//
//  HomeViewController.swift
//  ALC_RB
//
//  Created by user on 21.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

var segmentIndex = 0

class HomeViewController: UIViewController {
    
    private lazy var newsTable: NewsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsTableViewController") as! NewsTableViewController
        
        self.add(childVC: viewController)
        
        return viewController
    }()
    private lazy var gamesTable: GamesTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "GamesTableViewController") as! GamesTableViewController
        
        self.add(childVC: viewController)
        
        return viewController
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstInit()
    }
    
    private func firstInit() {
        add(childVC: newsTable)
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                remove(childVC: gamesTable)
                add(childVC: newsTable)
                print("Case 0")
            case 1:
                remove(childVC: newsTable)
                add(childVC: gamesTable)
                print("Case 1")
            
            default:
                break
        }
    }
    
    func add(childVC viewController: UIViewController) {
        addChild(viewController)
        
        viewContainer.addSubview(viewController.view)
        
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove(childVC viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
