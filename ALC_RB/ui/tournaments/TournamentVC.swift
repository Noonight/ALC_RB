//
//  TournamentVC.swift
//  ALC_RB
//
//  Created by ayur on 04.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TournamentVC: UIViewController {

    @IBOutlet weak var segment_controller: UISegmentedControl!
    @IBOutlet weak var container_view: UIView!
    
    private lazy var myTournaments: TournamentsTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "TournamentsTableViewController") as! TournamentsTableViewController
        
        return viewController
    }()
    
    private lazy var tournamentsSearch: TournamentSearchVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "TournamentSearchVC") as! TournamentSearchVC
        
        return viewController
    }()
    
    private var segmentHelper: SegmentHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSegmentHelper()
        self.segmentHelper?.add(myTournaments)
    }
}

// MARK: EXTENSIONS


// MARK: SETUP

extension TournamentVC {
    
    func setupSegmentHelper() {
        self.segmentHelper = SegmentHelper(self, container_view)
    }
    
}

// MARK: ACTIONS

extension TournamentVC {
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segment_controller.selectedSegmentIndex {
        case 0:
            segmentHelper?.removeAll()
            segmentHelper?.add(myTournaments)
        case 1:
            segmentHelper?.removeAll()
            segmentHelper?.add(tournamentsSearch)
        default:
            break
        }
    }
    
}
