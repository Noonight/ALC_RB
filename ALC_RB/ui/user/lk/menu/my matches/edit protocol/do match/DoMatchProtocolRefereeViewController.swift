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
//        static let D_ACCEPT_MATCH = "Завершая матч вы подтверждаете протокол, изменения большне не будут доступны. Нажмите 'Сохранить протокол' если хотите внести изменения позже"
//        static let D_ACCEPT_MATCH = "Завершая матч вы сохраняете протокол, изменения будут доступны пока главный судья не подтвердит протокол"
        static let D_ACCEPT_MATCH_NOT_MAIN_REF = "Завершая матч вы сохраняете протокол, изменения будут доступны пока главный судья не подтвердит протокол. Для публикации главный судья должен подтвердить протокол"
        static let D_ACCEPT_MATCH_MAIN_REF = "Завершая матч вы сохраняете протокол, изменения будут доступны пока главный судья не подтвердит протокол. Т.к. вы являетесь главным судьеи вы можете сразу подтвердить протокол нажав на 'Подтвердить протокол', изменения больше не будут доступны, протокол будет опубликован."

        
        static let PROGRESS_1_PROTOCOL_SAVING       = "[1/2] Сохраняем протокол..."
        static let PROGRESS_2_PROTOCOL_ACCEPTING    = "[2/2] Подтверждаем протокл..."
        
        static let PROGRESS_1_PROTOCOL_SAVED    = "[1/2] Протокол сохранен"
        static let PROGRESS_2_PROTOCOL_ACCEPTED = "[2/2] Протокол подтвержден"
        
        static let SAVE_PROTOCOL = "Сохранить протокол"
        
        static let PROGRESS_PROTOCOL_SAVING = "Сохраняем протокол..."
        static let PROGRESS_PROTOCOL_SAVED  = "Протокол сохранен"
        
        static let FAILURE_ADD_EVENT    = "Добавить событие не удалось, вы можете сохранить ивент позже"
        static let DELETE               = "Удалить"
        static let LEAVE                = "Оставить"
        
        static let PROGRESS_DELETE_EVENT            = "Удаляем событие..."
        static let PROGRESS_DELETE_EVENT_COMPLETE   = "Событие удалено"
        static let RESTORE                          = "Восстановить"
        static let EVENT_NOT_FOUND                  = "Событие не найдено."
        
        static let PROGRESS_ADD_EVENT           = "Добавляем событие..."
        static let PROGRESS_ADD_EVENT_COMPLETE  = "Событие добавлено"
    }
    enum Segues {
        static let REFEREES = "segue_edit_referees_do_protocol"
    }
    
    // MARK: OUTLETS
    
    @IBOutlet weak var titleTeamOne_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var titleTeamTwo_label: UILabel!
    
    @IBOutlet weak var foulsTeamOneCount_view: UIView!
    @IBOutlet weak var foulsTeamTwoCount_view: UIView!
    
    @IBOutlet weak var scoreAtTimeTeamOne_label: UILabel!
    @IBOutlet weak var scoreAtTimeTeamTwo_label: UILabel!
    
    @IBOutlet weak var playersOne_table: UITableView!
    @IBOutlet weak var playersTwo_table: UITableView!
    
    @IBOutlet weak var teamOne_width: NSLayoutConstraint!
    
    // MARK: Var & Let
    
    let userDefaults = UserDefaultsHelper()
    let presenter = DoMatchProtocolRefereePresenter()
    
    var viewModel: ProtocolRefereeViewModel!
    var playersTeamOne: ProtocolTeamOnePlayers = ProtocolTeamOnePlayers()
    var playersTeamTwo: ProtocolTeamTwoPlayers = ProtocolTeamTwoPlayers()
    
    var playersTeamOneAutoGoalsFooter: AutoGoalFooterView = AutoGoalFooterView()
    var playersTeamTwoAutoGoalsFooter: AutoGoalFooterView = AutoGoalFooterView()
    
    var eventMaker: EventMaker?
    var foulsMaker: FoulsMaker?
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupTableDataSources()
        self.setupAutogoalsFooter()
        self.setupEventMaker()
        self.setupFoulsMaker()
        self.setupStaticView()
        self.setupDynamicView()
        self.setupTableViews()
        self.setupTableViewsActions()
        self.setupFoulsCounter()
    }
    
}

// MARK: EXTENSIONS

// MARK: SETUP

extension DoMatchProtocolRefereeViewController {
    
    func setupAutogoalsFooter() {
        self.playersTeamOneAutoGoalsFooter = AutoGoalFooterView(frame: CGRect(x: 0, y: 0, width: self.playersOne_table.frame.width, height: 40))
        self.playersOne_table.tableFooterView = self.playersTeamOneAutoGoalsFooter
        
        self.playersTeamTwoAutoGoalsFooter = AutoGoalFooterView(frame: CGRect(x: 0, y: 0, width: self.playersTwo_table.frame.width, height: 40))
        self.playersTwo_table.tableFooterView = self.playersTeamTwoAutoGoalsFooter
        
//        self.playersTeamOneAutoGoalsFooter.countOfGoals = self.viewModel.prepareAutogoalsCount(for: .one)
//        self.playersTeamTwoAutoGoalsFooter.countOfGoals = self.viewModel.prepareAutogoalsCount(for: .two)
        
        
        self.playersTeamOneAutoGoalsFooter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTeamOneAutoGoals)))
        self.playersTeamTwoAutoGoalsFooter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTeamTwoAutoGoals)))
    }
    
    func setupFoulsCounter() {
        self.foulsTeamOneCount_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTeamOneFouls)))
        self.foulsTeamTwoCount_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTeamTwoFouls)))
    }
    
    func setupEventMaker() {
        self.eventMaker = EventMaker(addEventBack:
        { addEvent in
            self.eventMakerCompleteWork_ADD(event: addEvent)
        }, deleteEventBack:
        { deleteEvent in
            self.eventMakerCompleteWork_DELETE(event: deleteEvent)
        })
    }
    
    func setupFoulsMaker() {
        self.foulsMaker = FoulsMaker(completeBack: { value in
            self.foulsMakerCompleteWork(value: value)
        })
    }
    
    func setupTableViewsActions() {
        self.playersTeamOne.cellActions = self
        self.playersTeamTwo.cellActions = self
    }
    
    func setupTableDataSources() {
        let teamOneHud = self.playersOne_table.showLoadingViewHUD(with: Constants.Texts.CONFIGURE)
        self.viewModel.prepareTableViewCells(team: .one)
        { dataSource in
            self.playersTeamOne.dataSource = dataSource
            
            teamOneHud.hide(animated: true)
            self.playersOne_table.reloadData()
        }
        
        let teamTwoHud = self.playersTwo_table.showLoadingViewHUD(with: Constants.Texts.CONFIGURE)
        self.viewModel.prepareTableViewCells(team: .two)
        { dataSource in
            self.playersTeamTwo.dataSource = dataSource
            
            teamTwoHud.hide(animated: true)
            self.playersTwo_table.reloadData()
        }
    }
    
    func setupDynamicView() {
        
        // setup score // mb calculate before
        self.score_label.text = self.viewModel.match.score
        
        self.updateUIFouls()
        self.updateUIAutoGoals()
    }
    
    func setupStaticView() {
        self.titleTeamOne_label.text = ClubTeamHelper.getTeamTitle(league: viewModel.leagueDetailModel.leagueInfo.league, match: viewModel.match, team: .one)
        self.titleTeamTwo_label.text = ClubTeamHelper.getTeamTitle(league: viewModel.leagueDetailModel.leagueInfo.league, match: viewModel.match, team: .two)
    }
    
    func setupTableViews() {
        self.playersOne_table.dataSource    = self.playersTeamOne
        self.playersOne_table.delegate      = self.playersTeamOne
        
        self.playersTwo_table.dataSource    = self.playersTeamTwo
        self.playersTwo_table.delegate      = self.playersTeamTwo
    }
    
    func setupPresenter() {
        self.initPresenter()
    }
}

// MARK: ACTIONS

extension DoMatchProtocolRefereeViewController {
    
    @objc func tapTeamOneAutoGoals() {
        self.viewModel.upAutoGoalsCount(team: .one)
        
        self.addEventSaveProtocol()
    }
    
    @objc func tapTeamTwoAutoGoals() {
        self.viewModel.upAutoGoalsCount(team: .two)
        
        self.addEventSaveProtocol()
    }
    
    @objc func tapTeamOneFouls() {
        self.viewModel.upFoulsCount(team: .one)
        
        self.addEventSaveProtocol()
    }
    
    @objc func tapTeamTwoFouls() {
        self.viewModel.upFoulsCount(team: .two)
        
        self.addEventSaveProtocol()
    }
    
    func foulsMakerCompleteWork(value: Int) {
        // do smth 
    }
    
    func eventMakerCompleteWork_ADD(event: LIEvent) { // TODO : need work with data base or smth
        self.viewModel.appendEvent(event: event)
        
        let hud = self.showLoadingViewHUD(with: Texts.PROGRESS_ADD_EVENT)
        
        self.presenter.saveProtocol(
            token: self.userDefaults.getToken(),
            editedProtocol: self.viewModel.prepareEditProtocol(),
        ok: { match in
                self.viewModel.updateMatch(match: match.match!.convertToLIMatch())
                hud.showSuccessAfterAndHideAfter(withMessage: Texts.PROGRESS_ADD_EVENT_COMPLETE)
                
                self.setupTableDataSources()
                self.setupDynamicView()
        },
        failure: { error in
                hud.hide(animated: true)
                
                let delete = UIAlertAction(title: Texts.DELETE, style: .default)
                { alerter in
                    self.viewModel.deleteLastAddedEvent()
                    
                    self.setupTableDataSources()
                    self.setupDynamicView()
                }
                
                let leave = UIAlertAction(title: Texts.LEAVE, style: .cancel)
                { alerter in
                    Print.m("NOTHING")
                    
                    self.setupTableDataSources()
                    self.setupDynamicView()
                }
                
                self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription, actions: [delete, leave])
        })
    }
    
    func eventMakerCompleteWork_DELETE(event: EventMaker.DeleteEvent) {
        if self.viewModel.removeEvent(event: event) == true // event delete successful
        {
            let hud = self.showLoadingViewHUD(with: Texts.PROGRESS_DELETE_EVENT)
            
            self.presenter.saveProtocol(
                token: userDefaults.getToken(),
                editedProtocol: self.viewModel.prepareEditProtocol(),
                ok: { match in
                    self.viewModel.updateMatch(match: match.match!.convertToLIMatch())
                    hud.showSuccessAfterAndHideAfter(withMessage: Texts.PROGRESS_DELETE_EVENT_COMPLETE)
                    
                    self.setupTableDataSources()
                    self.setupDynamicView()
            },
                failure: { error in
                    hud.hide(animated: true)
                    
                    let restore = UIAlertAction(title: Texts.RESTORE, style: .default, handler:
                    { alerter in
                        self.viewModel.restoreLastDeletedEvent()
                        
                        self.setupTableDataSources()
                        self.setupDynamicView()
                    })
                    
                    let leave = UIAlertAction(title: Texts.LEAVE, style: .cancel)
                    { alerter in
                        Print.m("NOTHING")
                        
                        self.setupTableDataSources()
                        self.setupDynamicView()
                    }
                    
                    self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription, actions: [restore, leave])
            })
        }
        else // nothing to delete. Event by params not found
        {
            let hud = self.showToastHUD(message: Texts.EVENT_NOT_FOUND)
            hud.hideAfter(seconds: 2)
        }
    }
    
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

//                Print.m("token \(self.userDefaults.getToken()) ,, matchId \(self.viewModel.prepareMatchId())")
                
                self.presenter.acceptProtocol(
                    token: self.userDefaults.getToken(),
                    matchId: self.viewModel.prepareMatchId(),
                ok: { match in
                    hud.setDetailMessage(with: Texts.PROGRESS_2_PROTOCOL_ACCEPTED)
                    // do some staff for saving status of accepted match
                    guard let newMatch = match.match else {
                        hud.showSuccessAfterAndHideAfter()
                        return
                    }
                    
                    self.userDefaults.setMatch(match: newMatch)
                    hud.showSuccessAfterAndHideAfter()
                },
                response_message: { message in
                    hud.hide(animated: true)
                    
                    self.showAlert(title: message.message, message: "")
                },
                failure: { error in
                    hud.hide(animated: true)
                    
                    self.showAlert(message: error.localizedDescription)
                    Print.m(error)
                })
                
//                self.presenter.acceptProtocol(
//                    token: self.userDefaults.getToken(),
//                    matchId: self.viewModel.prepareMatchId(),
//                ok: { message in // protocol accepted
//                    hud.setDetailMessage(with: Texts.PROGRESS_2_PROTOCOL_ACCEPTED)
//                    // do some staff for saving status of accepted match
//
//                    hud.showSuccessAfterAndHideAfter()
//                }, failure: { error in // protocol not accepted
//
//                })

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
        
        if userDefaults.getAuthorizedUser()?.person.getUserType() == Person.TypeOfPerson.mainReferee // main ref here
        {
            showAlert(title: Texts.Q_ACCEPT_MATCH, message: Texts.D_ACCEPT_MATCH_MAIN_REF, actions: [acceptProtocol, saveProtocol, cancel])
        }
        else
        {
            showAlert(title: Texts.Q_ACCEPT_MATCH, message: Texts.D_ACCEPT_MATCH_NOT_MAIN_REF, actions: [saveProtocol, cancel])
        }
    }
    
    @IBAction func onFirstTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.updateTime(time: .oneHalf)
//        self.viewModel.currentTime = .firstTime
        self.title = self.viewModel.prepareCurrentTime()
        self.updateUIFouls()
    }
    
    @IBAction func onSecondTimeBtnPressed(_ sender: UIButton) {
//        self.viewModel.currentTime = .secondTime
        self.viewModel.updateTime(time: .twoHalf)
        self.title = self.viewModel.prepareCurrentTime()
        self.updateUIFouls()
    }
    
    @IBAction func onMoreTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.updateTime(time: .extraTime)
        self.title = self.viewModel.prepareCurrentTime()
        self.updateUIFouls()
    }
    
    @IBAction func onPenaltyTimeBtnPressed(_ sender: UIButton) {
        self.viewModel.updateTime(time: .penaltySeries)
        self.title = self.viewModel.prepareCurrentTime()
        self.updateUIFouls()
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

// MARK: HELPERS

extension DoMatchProtocolRefereeViewController {
    
    func addEventSaveProtocol() {
        let hud = self.showLoadingViewHUD(with: Texts.PROGRESS_ADD_EVENT)
        
        self.presenter.saveProtocol(
            token: self.userDefaults.getToken(),
            editedProtocol: self.viewModel.prepareEditProtocol(),
            ok: { match in
                self.viewModel.updateMatch(match: match.match!.convertToLIMatch())
                hud.showSuccessAfterAndHideAfter(withMessage: Texts.PROGRESS_ADD_EVENT_COMPLETE)
                
                self.setupTableDataSources()
                self.setupDynamicView()
        },
            failure: { error in
                hud.hide(animated: true)
                
                let delete = UIAlertAction(title: Texts.DELETE, style: .default)
                { alerter in
                    self.viewModel.deleteLastAddedEvent()
                    
                    self.setupTableDataSources()
                    self.setupDynamicView()
                }
                
                let leave = UIAlertAction(title: Texts.LEAVE, style: .cancel)
                { alerter in
                    Print.m("NOTHING")
                    
                    self.setupTableDataSources()
                    self.setupDynamicView()
                }
                
                self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription, actions: [delete, leave])
        })
    }
    
    func updateUIFouls() {
        self.scoreAtTimeTeamOne_label.text = String(self.viewModel.prepareFoulsCountInCurrentTime(team: .one))
        self.scoreAtTimeTeamTwo_label.text = String(self.viewModel.prepareFoulsCountInCurrentTime(team: .two))
    }
    
    func updateUIAutoGoals() {
        self.playersTeamOneAutoGoalsFooter.countOfGoals = self.viewModel.prepareAutogoalsCountInCurrentTime(team: .one)
        self.playersTeamTwoAutoGoalsFooter.countOfGoals = self.viewModel.prepareAutogoalsCountInCurrentTime(team: .two)
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
