//
//  DoMatchProtocolRefereeViewController.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class DoMatchProtocolRefereeViewController: UIViewController {
    enum Texts {
        static let FIRST_TIME   = "1 тайм"
        static let SECOND_TIME  = "2 тайм"
        static let MORE_TIME    = "Дополнительное время"
        static let PENALTY      = "Серия пенальти"
        
        static let ACCEPT_PROTOCOL = "Подтвердить протокол"
        
        static let Q_ACCEPT_MATCH = "Завершить матч?"
        static let D_ACCEPT_MATCH = "Завершая матч вы подтверждаете протокол, изменения большне не будут доступны. Нажмите 'Сохранить протокол' если хотите внести изменения позже"
        
        static let PROGRESS_1_PROTOCOL_SAVING       = "[1/2] Сохраняем протокол..."
        static let PROGRESS_2_PROTOCOL_ACCEPTING    = "[2/2] Подтверждаем протокл..."
        
        static let PROGRESS_1_PROTOCOL_SAVED    = "[1/2] Протокол сохранен"
        static let PROGRESS_2_PROTOCOL_ACCEPTED = "[2/2] Протокол подтвержден"
        
        static let SAVE_PROTOCOL = "Сохранить протокол"
        
        static let PROGRESS_PROTOCOL_SAVING = "Сохраняем протокол..."
        static let PROGRESS_PROTOCOL_SAVED  = "Протокол сохранен"
    }
    enum Segues {
        static let REFEREES = "segue_edit_referees_do_protocol"
    }
    
    // MARK: OUTLETS
    
    @IBOutlet weak var titleTeamOne_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var titleTeamTwo_label: UILabel!
    
    @IBOutlet weak var scoreAtTimeTeamOne_label: UILabel!
    @IBOutlet weak var scoreAtTimeTeamTwo_label: UILabel!
    
    @IBOutlet weak var playersOne_table: UITableView!
    @IBOutlet weak var playersTwo_table: UITableView!
    
    // MARK: Var & Let
    
    let userDefaults = UserDefaultsHelper()
    let presenter = DoMatchProtocolRefereePresenter()
    
    var viewModel: ProtocolRefereeViewModel!
    var playersTeamOne: ProtocolTeamOnePlayers = ProtocolTeamOnePlayers()
    var playersTeamTwo: ProtocolTeamTwoPlayers = ProtocolTeamTwoPlayers()
    
    var playersTeamOneAutoGoalsFooter: AutoGoalFooterView = AutoGoalFooterView()
    var playersTeamTwoAutoGoalsFooter: AutoGoalFooterView = AutoGoalFooterView()
    
//    var eventMaker: AddEventView = AddEventView()
    var eventMaker: EventMaker?
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupTableDataSources()
        self.setupEventMaker()
        self.setupView()
        self.setupTableViews()
        self.setupTableViewsActions()
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension DoMatchProtocolRefereeViewController {
    
    func setupEventMaker() {
        self.eventMaker = EventMaker(callBack:
        { liEvent in
            self.viewModel.appendEvent(event: liEvent)
//            dump(self.viewModel.eventsController)
            self.setupTableDataSources()
        })
    }
    
    func setupTableViewsActions() {
        self.playersTeamOne.cellActions = self
        self.playersTeamTwo.cellActions = self
    }
    
    func setupTableDataSources() {
        let teamOneHud = self.playersOne_table.showLoadingViewHUD()
        self.viewModel.prepareTableViewCells(team: .one)
        { dataSource in
            self.playersTeamOne.dataSource = dataSource
            
            teamOneHud.hide(animated: true)
            self.playersOne_table.reloadData()
        }
        
        let teamTwoHud = self.playersTwo_table.showLoadingViewHUD()
        self.viewModel.prepareTableViewCells(team: .two)
        { dataSource in
            self.playersTeamTwo.dataSource = dataSource
            
            teamTwoHud.hide(animated: true)
            self.playersTwo_table.reloadData()
        }
    }
    
    func setupView() {
        self.titleTeamOne_label.text = ClubTeamHelper.getTeamTitle(league: viewModel.leagueDetailModel.leagueInfo.league, match: viewModel.match, team: .one)
        self.titleTeamTwo_label.text = ClubTeamHelper.getTeamTitle(league: viewModel.leagueDetailModel.leagueInfo.league, match: viewModel.match, team: .two)
        // setup score // mb calculate before
        self.score_label.text = self.viewModel.match.score
    }
    
    func setupTableViews() {
        self.playersOne_table.dataSource    = self.playersTeamOne
        self.playersOne_table.delegate      = self.playersTeamOne
        
//        self.playersOne_table.tableFooterView = self.playersTeamOneAutoGoalsFooter
        
        self.playersTwo_table.dataSource    = self.playersTeamTwo
        self.playersTwo_table.delegate      = self.playersTeamTwo
        
//        self.playersTwo_table.tableFooterView = self.playersTeamTwoAutoGoalsFooter
    }
    
    func setupPresenter() {
        self.initPresenter()
    }
}

// MARK: ACTIONS

extension DoMatchProtocolRefereeViewController {
    
    @IBAction func onAcceptProtocolBtnPressed(_ sender: UIButton) {
        
        let acceptProtocol = UIAlertAction(title: Texts.ACCEPT_PROTOCOL, style: .default)
        { alerter in
            
            let hud = self.showLoadingViewHUD()
            hud.setDetailMessage(with: Texts.PROGRESS_1_PROTOCOL_SAVING)
            
            self.presenter.saveProtocol(
                token: self.userDefaults.getToken(),
                editedProtocol: self.viewModel.prepareEditProtocol(),
            ok: { match in // protocol saved
                
                hud.setDetailMessage(with: Texts.PROGRESS_2_PROTOCOL_ACCEPTING)
                
                self.presenter.acceptProtocol(
                    token: self.userDefaults.getToken(),
                    matchId: self.viewModel.prepareMatchId(),
                ok: { message in // protocol accepted
                    hud.setDetailMessage(with: Texts.PROGRESS_2_PROTOCOL_ACCEPTED)
                    // do some staff for saving status of accepted match
                    
                    hud.showSuccessAfterAndHideAfter()
                }, failure: { error in // protocol not accepted
                    
                })
                
            }, failure: { error in // protocol not saved
                Print.m(error)
                hud.setToFailureWith(detailMessage: error.localizedDescription)
                hud.hideAfter()
            })
        }
        
        let saveProtocol = UIAlertAction(title: Texts.SAVE_PROTOCOL, style: .default)
        { alerter in
            
            let hud = self.showLoadingViewHUD()
            hud.setDetailMessage(with: Texts.PROGRESS_PROTOCOL_SAVING)
            
            self.presenter.saveProtocol(
                token: self.userDefaults.getToken(),
                editedProtocol: self.viewModel.prepareEditProtocol(),
            ok: { match in
                hud.setDetailMessage(with: Texts.PROGRESS_PROTOCOL_SAVED)
                // do some staff for saving protocol to models
                
                hud.showSuccessAfterAndHideAfter()
            }, failure: { error in
                Print.m(error)
                hud.setToFailureWith(detailMessage: error.localizedDescription)
                hud.hideAfter()
            })
        }
        
        let cancel = UIAlertAction(title: Constants.Texts.CANCEL, style: .cancel)
        { alerter in
            // nothing
            Print.m("cancel pressed")
        }
        
        showAlert(title: Texts.Q_ACCEPT_MATCH, message: Texts.D_ACCEPT_MATCH, actions: [acceptProtocol, saveProtocol, cancel])
        
    }
    
    @IBAction func onFirstTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.currentTime = .firstTime
        self.title = self.viewModel.currentTime.rawValue
    }
    
    @IBAction func onSecondTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.currentTime = .secondTime
        self.title = self.viewModel.currentTime.rawValue
    }
    
    @IBAction func onMoreTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.currentTime = .moreTime
        self.title = self.viewModel.currentTime.rawValue
    }
    
    @IBAction func onPenaltyTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.currentTime = .penalty
        self.title = self.viewModel.currentTime.rawValue
    }
}

// MARK: TABLE ACITONS

extension DoMatchProtocolRefereeViewController: CellActions {
    func onCellSelected(model: CellModel)
    {
        let curModel = model as! RefereeProtocolPlayerTeamCellModel
        self.eventMaker!.showWith(
            matchId: self.viewModel.match.id,
            playerId: (curModel.player?.playerID)!,
            time: self.viewModel.currentTime.rawValue
        )
    }
}

// MARK: PRESENTER

extension DoMatchProtocolRefereeViewController: DoMatchProtocolRefereeView {
    func onSaveProtocolSuccess(match: SoloMatch) {
        print()
    }
    
    func onSaveProtocolFailure(error: Error) {
        print()
    }
    
    func onAcceptProtocolSuccess(message: SingleLineMessage) {
        print()
    }
    
    func onAcceptProtocolFailure(error: Error) {
        print()
    }
    
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
}

// MARK: NAVIGATION

extension DoMatchProtocolRefereeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.REFEREES,
            let destination = segue.destination as? EditRefereesProtocolViewController
        {
            destination.refereesController = self.viewModel.refereesController
            destination.viewModel?.comingMatch = self.viewModel.match
        }
    }
}