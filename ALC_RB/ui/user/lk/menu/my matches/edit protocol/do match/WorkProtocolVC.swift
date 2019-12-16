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
    
    @IBOutlet weak var teamOneFoulsCountView: UIView!
    @IBOutlet weak var teamTwoFoulsCountView: UIView!
    
    @IBOutlet weak var teamOneScoreAtTimeLabel: UILabel!
    @IBOutlet weak var teamTwoScoreAtTimeLabel: UILabel!
    
    @IBOutlet weak var teamOneBorderView: DesignableView!
    @IBOutlet weak var teamTwoBorderView: DesignableView!
    
    @IBOutlet weak var teamOneTableView: UITableView!
    @IBOutlet weak var teamTwoTableView: UITableView!
    
    var viewModel = WorkProtocolViewModel(protocolApi: ProtocolApi())
    var teamOneTable: ProtocolTeamOnePlayers!
    var teamTwoTable: ProtocolTeamTwoPlayers!
    
    let bag = DisposeBag()
    
    let teamOneFooter = AutoGoalFooterView()
    let teamTwoFooter = AutoGoalFooterView()
    
    var eventMaker: EventMaker?
    var autoGoalsMaker: AutoGoalsMaker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTables()
        setupViewBinds()
        setupEventMaker()
    }
    
}

// MARK: - SETUP

extension WorkProtocolVC {
    
    func setupViewBinds() {
        
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
}

// MARK: - ACTIONS

extension WorkProtocolVC {
    
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
