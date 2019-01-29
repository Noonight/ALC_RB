//
//  TeamLeagueDetailViewController.swift
//  ALC_RB
//
//  Created by ayur on 17.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamLeagueDetailViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    
    private lazy var playersTable: PlayersTeamLeagueDetailViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "PlayersTeamLeagueDetailViewController") as! PlayersTeamLeagueDetailViewController
        
        //viewController.leagueDetailModel = self.leagueDetailModel
        viewController.team = self.teamModel
        
        return viewController
    }()
    private lazy var matchesTable: MatchesTeamLeagueDetailTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "MatchesTeamLeagueDetailTableViewController") as! MatchesTeamLeagueDetailTableViewController
        
        //viewController.leagueDetailModel = self.leagueDetailModel
        viewController.team = self.teamModel
        
        return viewController
    }()
    var segmentHelper: SegmentHelper?
    
    var teamModel: LITeam = LITeam()
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentHelper?.remove(matchesTable)
            segmentHelper?.add(playersTable)
            break
        case 1:
            segmentHelper?.remove(playersTable)
            segmentHelper?.add(matchesTable)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        segmentHelper = SegmentHelper(self, viewContainer)
        firstSegmentInit()
        
        navigationController?.navigationBar.topItem?.title = " "
        title = teamModel.name
        //debugPrint(teamModel.name)
    }
    
    func firstSegmentInit() {
        segmentHelper?.add(playersTable)
    }
}
