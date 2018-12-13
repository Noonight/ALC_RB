//
//  TournamentDetailViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class LeagueDetailViewController: UIViewController, MvpView {
    
    private lazy var scheduleTable: ScheduleTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
        viewController.league = league
        viewController.leagueInfo = leagueInfo
        
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
    
    var league = League()
    var leagueInfo = LILeagueInfo()
    
    let presenter = LeagueDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        updateUI()
        initFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initView()
    }
    
    func initView() {
        stackView.addBackground(color: navigationController?.navigationBar.barTintColor ?? UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0))
        navigationController?.navigationBar.hideBorderLine()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getTournamentInfo(id: league.id)
    }
    
    func initFirst() {
        add(scheduleTable)
    }
    
    func updateUI() {
        mTitle.text = league.tourney
        
    }
    
    func onGetLeagueInfoSuccess(leagueInfo: LILeagueInfo) {
        self.leagueInfo = leagueInfo
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            add(scheduleTable)
//            remove()
//            remove()
//            add()
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
        
    }
    
    func add(_ viewController: UIViewController) {
        addChild(viewController)
        
        viewContainer.addSubview(viewController.view)
        
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
