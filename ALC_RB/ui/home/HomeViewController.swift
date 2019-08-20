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
    
    private lazy var newsTable: NewsAnnounceTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsTableViewController") as! NewsAnnounceTableViewController
        
        //self.add(childVC: viewController)
        
        return viewController
    }()
    private lazy var gamesTable: UpcomingGamesTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "UpcomingGamesTableViewController") as! UpcomingGamesTableViewController
        
        //self.add(childVC: viewController)
        
        return viewController
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!

//    let advertising = Advertising(adImage: UIImage(named: "ic_logo")!, adText: "Some test text")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstInit()
        
        segmentedControl.subviews.flatMap{$0.subviews}.forEach { subview in
            if let imageView = subview as? UIImageView, let image = imageView.image, image.size.width > 5 {
                // The imageView which isn't separator
                imageView.contentMode = .scaleAspectFit
                imageView.image = imageView.image?.imageWithInsets(insets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        advertising.showAd()
        
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
                //print("Case 0")
            case 1:
                remove(childVC: newsTable)
                add(childVC: gamesTable)
                //print("Case 1")
            
            default:
                break
        }
    }
    
    func add(childVC viewController: UIViewController) {
        addChild(viewController) // xcode 10+
        //addChildViewController(viewController)
        
        viewContainer.addSubview(viewController.view)
        
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove(childVC viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent() // xcode 10+
        //viewController.removeFromParentViewController()
    }
}
