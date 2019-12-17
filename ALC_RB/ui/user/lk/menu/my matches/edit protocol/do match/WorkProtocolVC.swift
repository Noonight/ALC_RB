//
//  WorkProtocolVC.swift
//  ALC_RB
//
//  Created by ayur on 16.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SPStorkController

final class WorkProtocolVC: UIViewController {
    
    static func getInstance(match: Match) -> WorkProtocolVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "WorkProtocolVC") as! WorkProtocolVC
        
        viewController.viewModel.match = match
        
        return viewController
    }
    
    @IBOutlet weak var teamOneTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var teamTwoTitleLabel: UILabel!
    
    @IBOutlet weak var teamOneFoulsLabel: UILabel!
    @IBOutlet weak var teamTwoFoulsLabel: UILabel!
    
    @IBOutlet weak var teamOneBorderView: DesignableView!
    @IBOutlet weak var teamTwoBorderView: DesignableView!
    
    @IBOutlet weak var teamOneTableView: UITableView!
    @IBOutlet weak var teamTwoTableView: UITableView!
    
    @IBOutlet weak var eventsView: UIView!
    
    var viewModel = WorkProtocolViewModel(protocolApi: ProtocolApi())
    var teamOneTable: ProtocolTeamOnePlayers!
    var teamTwoTable: ProtocolTeamTwoPlayers!
    
    let bag = DisposeBag()
    
    var teamOneAutogoalFooter: AutoGoalFooterView!
    var teamTwoAutogoalFooter: AutoGoalFooterView!
    
    var eventMaker: EventMaker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTables()
        
        setupEventMaker()
        setupBorderViews()
        setupAutogoalsFooter()
        setupGestures()
        
        setupViewBinds()
    }
    
}

// MARK: - SETUP

extension WorkProtocolVC {
    
    func setupViewBinds() {
        
    }
    
    func setupView() {
        
    }
    
    func setupGestures() {
        teamOneBorderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTeamOneFoul(_:))))
        teamTwoBorderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTeamTwoFoul(_:))))
        
        eventsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eventsPressed(_:))))
        
        teamOneAutogoalFooter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTeamOneAutoGoal(_:))))
        teamTwoAutogoalFooter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addTeamTwoAutoGoal(_:))))
    }
    
    func setupTables() {
        teamOneTable = ProtocolTeamOnePlayers(cellActions: self)
        teamTwoTable = ProtocolTeamTwoPlayers(cellActions: self)
        
        teamOneTableView.delegate = teamOneTable
        teamOneTableView.dataSource = teamOneTable
        
        teamTwoTableView.delegate = teamTwoTable
        teamTwoTableView.dataSource = teamTwoTable
    }
    
    func setupEventMaker() {
        self.eventMaker = EventMaker(callBack: self)
    }
    
    func setupAutogoalsFooter() {
        teamOneAutogoalFooter = AutoGoalFooterView(frame: CGRect(x: 0, y: 0, width: teamOneTableView.frame.width, height: AutoGoalFooterView.HEIGHT))
        teamOneTableView.tableFooterView = teamOneAutogoalFooter
        
        teamTwoAutogoalFooter = AutoGoalFooterView(frame: CGRect(x: 0, y: 0, width: teamTwoTableView.frame.width, height: AutoGoalFooterView.HEIGHT))
        teamTwoTableView.tableFooterView = teamTwoAutogoalFooter
    }
    
    func setupBorderViews() {
        self.teamOneBorderView.borderWidth = 2
        self.teamOneBorderView.borderColor = .red
        self.teamTwoBorderView.borderWidth = 2
        self.teamTwoBorderView.borderColor = .red
    }
}

// MARK: - ACTIONS

extension WorkProtocolVC {
    
    @objc func addTeamOneFoul(_ sender: UIView) {
        self.showAlert(message: "team one foul")
    }
    
    @objc func addTeamTwoFoul(_ sender: UIView) {
        self.showAlert(message: "team two foul")
    }
    
    @objc func addTeamOneAutoGoal(_ sender: UIButton) {
        self.showAlert(message: "team one add autogoal")
    }
    
    @objc func addTeamTwoAutoGoal(_ sender: UIButton) {
        self.showAlert(message: "team two add autogoal")
    }
    
    @IBAction func firstHalfPressed(_ sender: UIButton) {
        self.showAlert(message: "first half")
    }
    
    @IBAction func secondHalfPressed(_ sender: UIButton) {
        self.showAlert(message: "second half")
    }
    
    @IBAction func extraTimePressed(_ sender: UIButton) {
        self.showAlert(message: "extra time")
    }
    
    @IBAction func penaltySeriesPressed(_ sender: UIButton) {
        self.showAlert(message: "penalty series")
    }
    
    @objc func eventsPressed(_ sender: UIView) {
        self.showAlert(message: "events")
    }
    
    @IBAction func endMatchPressed(_ sender: UIButton) {
        self.showAlert(message: "end match")
    }
}

// MARK: - TABLE ACTIONS

extension WorkProtocolVC: TableActions {
    
    func onCellSelected(model: CellModel) {
        
        if model is RefereeProtocolPlayerTeamCellModel {
            let model = model as! RefereeProtocolPlayerTeamCellModel
            self.eventMaker?.showWith(
                matchId: self.viewModel.match.id,
                playerId: model.person!.id,
                time: self.viewModel.time)
        } else { assertionFailure("not valid model") }
    }
    
}

// MARK: - EVENT MAKER CALL BACKS

extension WorkProtocolVC: EventMakerCallBack {
    
    func addCallBack(event: Event) {
        self.viewModel.match.events?.append(event)
        
        self.viewModel.request_saveProtocolEvents()
    }
}

// MARK: - HELPERS

extension WorkProtocolVC {
    
}

// MARK: - NAVIGATION

extension WorkProtocolVC {
    
}
