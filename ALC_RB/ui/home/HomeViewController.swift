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
    }
    
    private func firstInit() {
        segmentHelper?.add(all)
    }
    
}

// MARK: EXTENSIONS

// MARK: SETUP

extension HomeViewController {
    
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
        self.viewModel.fetchAnnounces(completed: { announces in
//            self.announcesTable?.dataSource = announces
            self.announces_table.reloadData()
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
