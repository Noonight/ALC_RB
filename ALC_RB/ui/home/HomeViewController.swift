//
//  HomeViewController.swift
//  ALC_RB
//
//  Created by user on 21.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var all : HomeAllVC = HomeAllVC()
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
    @IBOutlet weak var announces_table: UITableView!
    @IBOutlet weak var headerOfAnnounces_view: UIView!
    @IBOutlet weak var announces_table_height: NSLayoutConstraint!
    
    private var segmentHelper: SegmentHelper?
    
    private var announcesTable: HomeAnnouncesTable?
    private let viewModel = HomeViewModel()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSegmentHelper()
        self.setupAnnouncesTable()
        firstInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupAnnouncesDataSource()
        self.setupGesture()
    }
    
    private func firstInit() {
        segmentHelper?.add(all)
    }
    
}

// MARK: EXTENSIONS

// MARK: SETUP

extension HomeViewController {
    
    func setupGesture() {
        self.viewContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(gestureRecognizer:))))
    }
    
    @objc private func panGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let piece = gestureRecognizer.view
        
        let translation = gestureRecognizer.translation(in: piece?.superview)
        if gestureRecognizer.state == .began {
            // Save the view's original position.
//            self.initialCenter = piece.center
            Print.m(piece?.center)
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
//            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
//            piece.center = newCenter
            Print.m("\(translation.x) + \(translation.y)")
        }
        else {
            // On cancellation, return the piece to its original location.
//            piece.center = initialCenter
            Print.m("\(piece?.center)")
        }
    }
    
    func setupSegmentHelper() {
        self.segmentHelper = SegmentHelper(self, viewContainer)
    }
    
    func setupAnnouncesTable() {
        self.announcesTable = HomeAnnouncesTable(actions: self)
        self.announces_table.delegate = self.announcesTable
        self.announces_table.dataSource = self.announcesTable
        self.announces_table.register(self.announcesTable?.cellNib, forCellReuseIdentifier: HomeAnonunceTableViewCell.ID)
    }
    
    func setupAnnouncesDataSource() {
        let hud = self.announces_table.showLoadingViewHUD()
        self.viewModel.fetchAnnounces(completed: {
            hud.hide(animated: true)
            if self.viewModel.prepareAnnounces() != nil
            {
                self.announcesTable?.dataSource = self.viewModel.prepareAnnounces()!
                self.announces_table.reloadData()
            }
            else
            if self.viewModel.prepareMessage() != nil
            {
                self.announces_table.showMessageHUD(message: self.viewModel.prepareMessage()!.message)
            }
            else
            if self.viewModel.prepareError() != nil
            {
                let hud = self.announces_table.showButtonHUD
                {
                    self.viewModel.fetchAnnounces
                    {
                        self.announcesTable!.dataSource = self.viewModel.prepareAnnounces()!
                        self.announces_table.reloadData()
                    }
                }
                hud.hideAfter()
            }
        })
    }
    
}

// MARK: ACTIONS

extension HomeViewController {
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentHelper?.removeAll()
            segmentHelper?.add(all)
        case 1: // My tournaments
            segmentHelper?.removeAll()
//            segmentHelper?.add(myTournaments)
        case 2: // News
            segmentHelper?.removeAll()
            segmentHelper?.add(newsTable)
        case 3: // Schedule
            segmentHelper?.removeAll()
//            segmentHelper?.add(schedule)
        default:
            break
        }
    }
}

// MARK: CELL ACTIONS

extension HomeViewController: CellActions {
    func onCellSelected(model: CellModel) {
        switch model {
        case is AnnounceElement:
            Print.m("the model of element is AnnounceElement")
            return
        default:
            return
        }
    }
}
