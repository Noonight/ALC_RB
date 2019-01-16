//
//  TournamentDetailViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

struct LeagueDetailModel {
    var league = League()
    var leagueInfo = LILeagueInfo()

    init() { }
    
    init (_ league: League) {
        self.league = league
    }
}

protocol LeagueMainProtocol {
    /// updating data in controller
    func updateData(leagueDetailModel: LeagueDetailModel)
}

class LeagueDetailViewController: UIViewController {
    
    private lazy var scheduleTable: ScheduleTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
        viewController.leagueDetailModel.league = self.leagueDetailModel.league
        viewController.leagueDetailModel.leagueInfo = self.leagueDetailModel.leagueInfo
        
        //self.add(viewController)
        
        return viewController
    }()
//    private lazy var teamsTable
//    private lazy var playersTable

    
    //MARK: - Outlets    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mTitle: UILabel!
    
    var leagueDetailModel = LeagueDetailModel()
    
    let presenter = LeagueDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        initFirst()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initView()
    }
    
    func initView() {
        stackView.addBackground(color: navigationController?.navigationBar.barTintColor ?? UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0))
        navigationController?.navigationBar.hideBorderLine()
    }
    
    func initFirst() {
        add(scheduleTable)
    }
    
    func updateUI() {
        scheduleTable.leagueDetailModel = self.leagueDetailModel
        mTitle.text = leagueDetailModel.league.tourney
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
//            remove()
//            remove()
            add(scheduleTable)
//            add()
            break
        case 1:
            remove(scheduleTable)
            break
        case 2:
            break
        default:
            break
        }
        
    }
    
    func add(_ viewController: UIViewController) {
        addChild(viewController) // xcode 10+
        //addChildViewController(viewController)
        
        viewContainer.addSubview(viewController.view)
        
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent() // xcode 10+
        //viewController.removeFromParentViewController()
    }
}

extension LeagueDetailViewController: LeagueDetailView {
    func onGetLeagueInfoSuccess(leagueInfo: LILeagueInfo) {
        self.leagueDetailModel.leagueInfo = leagueInfo
        //scheduleTable.leagueDetailModel = self.leagueDetailModel
        //print(leagueInfo)
        //try! debugPrint(leagueDetailModel.leagueInfo.jsonString())
        updateUI()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getTournamentInfo(id: leagueDetailModel.league.id)
    }
}
