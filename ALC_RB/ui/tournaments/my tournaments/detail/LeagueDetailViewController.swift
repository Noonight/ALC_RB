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
    private enum Variables {
        static let errorAlertTitle = "Ошибка!"
        static let errorAlertOk = "Ок"
        static let errorAlertRefresh = "Перезагрузка"
    }
    
    @IBOutlet weak var announce_view: UIView!
    @IBOutlet weak var announce_height: NSLayoutConstraint!
    @IBOutlet weak var announce_label: UILabel!
    
    private lazy var scheduleTable: ScheduleTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
        viewController.leagueDetailModel.league = self.leagueDetailModel.league
        viewController.leagueDetailModel.leagueInfo = self.leagueDetailModel.leagueInfo
        
        return viewController
    }()
    private lazy var teamsTable: TeamsLeagueTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "TeamsLeagueTableViewController") as! TeamsLeagueTableViewController
        
        viewController.leagueDetailModel = self.leagueDetailModel
        
        return viewController
    }()
    private lazy var playersTable: PlayersLeagueDetailViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "PlayersLeagueDetailViewController") as! PlayersLeagueDetailViewController
        
        viewController.leagueDetailModel = self.leagueDetailModel
        
        return viewController
    }()

    
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
        presenter.getTournamentInfo(id: leagueDetailModel.league.id!)
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
            remove(teamsTable)
            remove(playersTable)
//            remove()
            add(scheduleTable)
//            add()
            break
        case 1:
            remove(scheduleTable)
            remove(playersTable)
            add(teamsTable)
            break
        case 2:
            remove(scheduleTable)
            remove(teamsTable)
            add(playersTable)
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
    func onGetLeagueInfoFailure(error: Error) {
//        showAlert(title: Variables.errorAlertTitle, message: error.localizedDescription, actions:
//            [
//                UIAlertAction(title: Variables.errorAlertOk, style: .default, handler: nil),
//                UIAlertAction(title: Variables.errorAlertRefresh, style: .default, handler: { (alertAction) in
//
//                })
//            ]
//        )
        showRefreshAlert(message: error.localizedDescription) {
            self.presenter.getTournamentInfo(id: self.leagueDetailModel.league.id!)
        }
    }
    
    func onGetLeagueInfoSuccess(leagueInfo: LILeagueInfo) {
        self.leagueDetailModel.leagueInfo = leagueInfo
//        self.scheduleTable.leagueDetailModel.leagueInfo = leagueInfo
        //scheduleTable.leagueDetailModel = self.leagueDetailModel
        //print(leagueInfo)
        //try! debugPrint(leagueDetailModel.leagueInfo.jsonString())
        scheduleTable.updateData(leagueDetailModel: self.leagueDetailModel)
        updateUI()
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
