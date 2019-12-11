//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import loady
import RxSwift
import RxCocoa

protocol EditMatchProtocolCallBack {
    func back(match: Match)
}

class EditMatchProtocolViewController: UIViewController {
    
    lazy var editTeamPlayersVC: EditTeamProtocolVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var editTeamPlayersVC = storyboard.instantiateViewController(withIdentifier: "EditTeamProtocolVC") as! EditTeamProtocolVC
        
        return editTeamPlayersVC
    }()
    
    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    
    @IBOutlet weak var teamOneBtn: Loady!
    @IBOutlet weak var teamTwoBtn: Loady!
    @IBOutlet weak var refereesBtn: Loady!
    @IBOutlet weak var eventsBtn: UIButton!
    
    @IBOutlet weak var workProtocolBtn: Loady!
    
    @IBOutlet weak var teamOneView: UIView!
    @IBOutlet weak var teamTwoView: UIView!
    @IBOutlet weak var refereesView: UIView!
    
//    var leagueDetailModel: LeagueDetailModel!
//    var match = Match()
    
    var back: EditMatchProtocolCallBack?
    let presenter = EditMatchProtocolPresenter(teamApi: TeamApi(), personApi: PersonApi(), matchApi: MatchApi())
    
    // MARK: - Model Controllers
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupNavController()
        self.setupView()
        
    }
    
//    override func willMove(toParent parent: UIViewController?) {
//        // if parent is nil, vc is poped from navigation stack
//        // it means we go back
//        // TEST IT
//        if parent == nil {
//            self.back?.back(match: self.presenter.match)
//            Print.m("Move to parent. Parent is MyMatchesTVC")
//        }
//    }
    
    override func didMove(toParent parent: UIViewController?) {
        // if parent is nil, vc is poped from navigation stack
        // it means we go back
        // TEST IT
        if parent == nil {
            self.back?.back(match: self.presenter.match)
            Print.m("Move to parent. Parent is MyMatchesTVC")
        }
    }
}

// MARK: - SETUP

extension EditMatchProtocolViewController {
    
    func setupPresenter() {
        self.initPresenter()
    }
    
    func setupView() {
        
        teamOneTitle.text = self.presenter.match.teamOne?.getValue()?.name ?? "Не назначена"
        teamTwoTitle.text = self.presenter.match.teamTwo?.getValue()?.name ?? "Не назначена"
        
        teamOneBtn.indicatorViewStyle = true
        teamTwoBtn.indicatorViewStyle = true
        refereesBtn.indicatorViewStyle = true
        workProtocolBtn.indicatorViewStyle = true
        
        teamOneBtn.stopLoading()
        teamTwoBtn.stopLoading()
        refereesBtn.stopLoading()
        workProtocolBtn.stopLoading()
        
        self.teamOneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamOnePressed(_:))))
        self.teamTwoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamTwoPressed(_:))))
        self.refereesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refereesPressed(_:))))
        self.workProtocolBtn.addTarget(self, action: #selector(doMatchPressed(_:)), for: .touchUpInside)
    }
    
    func setupNavController() {
        navigationController?.navigationBar.topItem?.title = " "
        title = "Матч"
    }
    
}

// MARK: - ACTIONS

extension EditMatchProtocolViewController {
    
    @objc func teamOnePressed(_ sender: UIView) {
        Print.m("TEAM ONE")
        teamOneBtn.startLoading()
        self.presenter.fetchTeamPlayers(team: .one) { result in
            switch result {
            case .success(let fetchedTeam):
                
                self.showEditTeamPlayers(match: self.presenter.match, team: fetchedTeam)
                
                self.teamOneBtn.stopLoading()
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    @objc func teamTwoPressed(_ sender: UIView) {
        Print.m("TEAM TWO")
        teamTwoBtn.startLoading()
        self.showAlert(message: "Команда")
    }
    
    @objc func refereesPressed(_ sender: UIView) {
        Print.m("REFEREES")
        refereesBtn.startLoading()
        self.showAlert(message: "Судья")
    }
    
    @objc func doMatchPressed(_ sender: UIButton) {
        Print.m("WORK PROTOCOL")
//        workProtocolBtn.startLoading()
        self.showAlert(message: "Рабочий протокол")
    }
    
}

// MARK: - HELPERS

extension EditMatchProtocolViewController {
    
    func connectPlayersOfTeamOneAndTwo() -> [Person] {
        return [teamOnePlayersController.getPlayingPlayers(), teamTwoPlayersController.getPlayingPlayers()].flatMap({ liPlayer -> [Person] in
            return liPlayer
        })
    }
    
}

// MARK: - EditTeamPlayersCallBack

extension EditMatchProtocolViewController: EditTeamPlayersCallBack {
    func back(match: Match) {
        // TODO: fetch the match or smth
        if navigationController?.viewControllers.last is EditTeamProtocolVC {
            navigationController?.popViewController(animated: true)
        }
        
    }
}

// MARK: - NAVIGATION

extension EditMatchProtocolViewController {
    
    func showEditTeamPlayers(match: Match, team: Team) {
        
        editTeamPlayersVC.viewModel = EditTeamProtocolViewModel(matchApi: MatchApi())
        editTeamPlayersVC.viewModel.match = BehaviorRelay<Match?>(value: match)
        editTeamPlayersVC.viewModel.team = BehaviorRelay<Team?>(value: team)
        editTeamPlayersVC.back = self
        
        self.show(editTeamPlayersVC, sender: self)
    }
    
    func showEditReferees(match: Match) {
        Print.m("match is \(match)")
        self.showAlert(message: "Edit match referees")
    }
    
}

// MARK: Presenter

extension EditMatchProtocolViewController: EditMatchProtocolView {
    func requestAcceptProtocolSuccess(message: SingleLineMessage) {
        showAlert(title: message.message, message: "")
    }
    
    func requestAcceptProtocolFailure(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    func requestEditProtocolSuccess(match: Match) {
        
//        user?.person.participationMatches?.removeAll(where: { $0.isEqual({ $0.id == match.match?.id }) })
//        user?.person.participationMatches!.removeAll(where: { pMatch -> Bool in
//            return pMatch.id == match.match?.id
//        })
//        user?.person.participationMatches!.append(IdRefObjectWrapper(match.match!))
        
        showAlert(title: "Протокол сохранен", message: "")
    }
    
    func requestEditProtocolMessage(message: SingleLineMessage) {
        showAlert(message: message.message)
    }
    
    func requestEditProtocolFailure(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

extension EditMatchProtocolViewController: SaveProtocol {
    func save() {
        Print.m("save staff")
//        let request = EditProtocol(
//            id: self.match.id,
////            events: EditProtocol.Events(events: self.eventsController.events),
////            playersList: connectPlayersOfTeamOneAndTwo().map({ liPlayer -> String in
////                return liPlayer.playerId
////            })
//        )
//        self.presenter.requestEditProtocol(
//            token: (self.userDefaults.getAuthorizedUser()?.token)!,
//            editProtocol: request
//        )
    }
}
