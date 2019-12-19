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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setupTables()
    }
    
}

// MARK: - SETUP

extension WorkProtocolVC {
    
    func setupViewBinds() {
        
        viewModel
            .teamOneEvents
            .observeOn(MainScheduler.instance)
            .map { events -> [RefereeProtocolPlayerTeamCellModel] in
//                Print.m(events)
                var cellModels = [RefereeProtocolPlayerTeamCellModel]()
                for event in events {
                    if let person = self.viewModel.match.playersList?.filter({ personObj -> Bool in
                        return personObj.getId() ?? personObj.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
                    }).first {
                        if !cellModels.contains(where: { cellModel -> Bool in
                            return cellModel.person?.id == person.getId() ?? person.getValue()?.id
                        }) {
                            let goals = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .goal
                            }).count
                            let penalties = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .penalty
                            }).count
                            let failurePenalties = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .penaltyFailure
                            }).count
                            let yellowCards = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .yellowCard
                            }).count
                            let redCard = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .redCard
                            }).count > 0 ? true : false
                            let personEvents = RefereeProtocolPlayerEventsModel(goals: goals, successfulPenaltyGoals: penalties, failurePenaltyGoals: failurePenalties, yellowCards: yellowCards, redCard: redCard)
                            cellModels.append(RefereeProtocolPlayerTeamCellModel(person: person.getValue()!, eventsModel: personEvents))
                        }
                    }
                }
                return cellModels
            }
            .subscribe { elements in
                guard let cellModels = elements.element else { return }
                self.teamOneTable.dataSource = cellModels
                self.teamOneTableView.reloadData()
            }.disposed(by: bag)
        
        viewModel
            .teamTwoEvents
            .map { events -> [RefereeProtocolPlayerTeamCellModel] in
//                Print.m(events)
                var cellModels = [RefereeProtocolPlayerTeamCellModel]()
                for event in events {
                    if let person = self.viewModel.match.playersList?.filter({ personObj -> Bool in
                        return personObj.getId() ?? personObj.getValue()?.id == event.player?.getId() ?? event.player?.getValue()?.id
                    }).first {
                        if !cellModels.contains(where: { cellModel -> Bool in
                            return cellModel.person?.id == person.getId() ?? person.getValue()?.id
                        }) {
                            let goals = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .goal
                            }).count
                            let penalties = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .penalty
                            }).count
                            let failurePenalties = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .penaltyFailure
                            }).count
                            let yellowCards = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .yellowCard
                            }).count
                            let redCard = events.filter({ gEvent -> Bool in
                                return gEvent.player?.getId() ?? gEvent.player?.getValue()?.id == person.getId() ?? person.getValue()?.id && gEvent.type == .redCard
                            }).count > 0 ? true : false
                            let personEvents = RefereeProtocolPlayerEventsModel(goals: goals, successfulPenaltyGoals: penalties, failurePenaltyGoals: failurePenalties, yellowCards: yellowCards, redCard: redCard)
                            cellModels.append(RefereeProtocolPlayerTeamCellModel(person: person.getValue()!, eventsModel: personEvents))
                        }
                    }
                }
                return cellModels
            }.subscribe { elements in
                guard let cellModels = elements.element else { return }
                self.teamTwoTable.dataSource = cellModels
                self.teamTwoTableView.reloadData()
            }.disposed(by: bag)
        
        viewModel
            .rxTime
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                guard let time = element.element else { return }
                self.title = time.ru()
            }.disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.error)
        .disposed(by: bag)
        
        viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
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
        viewModel.request_addEvent(event: viewModel.createEvent(teamId: viewModel.match.teamOne?.getId() ?? (viewModel.match.teamOne?.getValue()?.id)!, type: .foul))
    }
    
    @objc func addTeamTwoFoul(_ sender: UIView) {
        viewModel.request_addEvent(event: viewModel.createEvent(teamId: viewModel.match.teamTwo?.getId() ?? (viewModel.match.teamTwo?.getValue()?.id)!, type: .foul))
    }
    
    @objc func addTeamOneAutoGoal(_ sender: UIButton) {
        viewModel.request_addEvent(event: viewModel.createEvent(teamId: viewModel.match.teamOne?.getId() ?? (viewModel.match.teamOne?.getValue()?.id)!, type: .autoGoal))
    }
    
    @objc func addTeamTwoAutoGoal(_ sender: UIButton) {
        viewModel.request_addEvent(event: viewModel.createEvent(teamId: viewModel.match.teamTwo?.getId() ?? (viewModel.match.teamTwo?.getValue()?.id)!, type: .autoGoal))
    }
    
    @IBAction func firstHalfPressed(_ sender: UIButton) {
        viewModel.time = .firstHalf
    }
    
    @IBAction func secondHalfPressed(_ sender: UIButton) {
        viewModel.time = .secondHalf
    }
    
    @IBAction func extraTimePressed(_ sender: UIButton) {
        viewModel.time = .extraTime
    }
    
    @IBAction func penaltySeriesPressed(_ sender: UIButton) {
        viewModel.time = .penaltySeries
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
            if viewModel.match.teamOne?.getValue()?.players?.contains(where: { player -> Bool in
                return player.person?.getId() ?? player.person?.getValue()?.id == model.person?.id
            }) ?? false {
                self.eventMaker?.showWith(
                    matchId: self.viewModel.match.id,
                    playerId: model.person!.id,
                    teamId: viewModel.match.teamOne?.getId() ?? (viewModel.match.teamOne?.getValue()?.id)!,
                    time: self.viewModel.time)
            } else if viewModel.match.teamTwo?.getValue()?.players?.contains(where: { player -> Bool in
                return player.person?.getId() ?? player.person?.getValue()?.id == model.person?.id
            }) ?? false {
                self.eventMaker?.showWith(
                    matchId: self.viewModel.match.id,
                    playerId: model.person!.id,
                    teamId: viewModel.match.teamTwo?.getId() ?? (viewModel.match.teamTwo?.getValue()?.id)!,
                    time: self.viewModel.time)
            } else {
                assertionFailure("team not found")
            }
        } else { assertionFailure("not valid model") }
    }
    
}

// MARK: - EVENT MAKER CALL BACKS

extension WorkProtocolVC: EventMakerCallBack {
    
    func addCallBack(event: Event) {
        self.viewModel.match.events?.append(event)
        
        self.viewModel.request_addEvent(event: event)
//        self.viewModel.request_saveProtocolEvents()
    }
}

// MARK: - HELPERS

extension WorkProtocolVC {
    
}

// MARK: - NAVIGATION

extension WorkProtocolVC {
    
    func showMatchEvents() {
        
    }
    
    func showPenaltySeriesModal() {
        
    }
    
}
