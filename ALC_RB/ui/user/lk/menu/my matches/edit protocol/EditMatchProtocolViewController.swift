//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import loady

class EditMatchProtocolViewController: UIViewController {
    
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
    
    var leagueDetailModel: LeagueDetailModel!
    var match = Match()
    
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
}

// MARK: - SETUP

extension EditMatchProtocolViewController {
    
    func setupPresenter() {
        self.initPresenter()
    }
    
    func setupView() {
        
        teamOneTitle.text = self.match.teamOne?.getValue()?.name ?? "Не назначена"
        teamTwoTitle.text = self.match.teamTwo?.getValue()?.name ?? "Не назначена"
        
        teamOneBtn.indicatorViewStyle = true
        teamTwoBtn.indicatorViewStyle = true
        refereesBtn.indicatorViewStyle = true
        workProtocolBtn.indicatorViewStyle = true
        self.teamOneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamOnePressed(_:))))
        self.teamTwoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamTwoPressed(_:))))
        self.refereesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refereesPressed(_:))))
        self.workProtocolBtn.addTarget(self, action: #selector(doMatchPressed(_:)), for: .touchUpInside)
    }
    
    func setupNavController() {
        navigationController?.navigationBar.topItem?.title = " "
        title = "Матч"
        if #available(iOS 11.0, *) {
            //            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)]
            //            self.navigationController?.navigationBar.prefersLargeTitles = true
            //            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    // MARK: - PRE CONFIGURE Model Controllers
    
    func preConfigureModelControllers() {
        teamOnePlayersController = nil
        teamTwoPlayersController = nil
        //        teamOnePlayersController = ProtocolPlayersController(players: getPlayersTeam(team: match.teamOne!))
        //        teamOnePlayersController = ProtocolPlayersController(teamPlayers: getPlayersTeam(team: match.teamOne!), matchPlayers: getMatchPlayers(team: match.teamOne!))
        ////        teamTwoPlayersController = ProtocolPlayersController(players: getPlayersTeam(team: match.teamTwo!))
        //        teamTwoPlayersController = ProtocolPlayersController(teamPlayers: getPlayersTeam(team: match.teamTwo!), matchPlayers: getMatchPlayers(team: match.teamTwo!))
        //        refereesController = nil
        //        refereesController = ProtocolRefereesController(referees: match.referees)
        //        eventsController = nil
        //        eventsController = ProtocolEventsController(events: match.events)
    }
}

// MARK: - ACTIONS

extension EditMatchProtocolViewController {
    
    @objc func teamOnePressed(_ sender: UIView) {
        Print.m("TEAM ONE")
//        teamOneBtn.startLoading()
        self.showAlert(message: "Команда")
    }
    
    @objc func teamTwoPressed(_ sender: UIView) {
        Print.m("TEAM TWO")
//        teamTwoBtn.startLoading()
        self.showAlert(message: "Команда")
    }
    
    @objc func refereesPressed(_ sender: UIView) {
        Print.m("REFEREES")
//        refereesBtn.startLoading()
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

// MARK: - NAVIGATION

extension EditMatchProtocolViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case SegueIdentifiers.TEAM_ONE:
//            prepareSegueDataModel(destination: segue.destination, team: .one)
//        case SegueIdentifiers.TEAM_TWO:
//            prepareSegueDataModel(destination: segue.destination, team: .two)
//        case SegueIdentifiers.REFEREES:
//            prepareSegueDataModel(destination: segue.destination)
//        case SegueIdentifiers.EVENTS:
//            prepareSegueDataModel(destination: segue.destination)
//        case SegueIdentifiers.DO_MATCH:
//            let controller = segue.destination as! DoMatchProtocolRefereeViewController
//            controller.viewModel = ProtocolRefereeViewModel(
//                match: self.match,
//                leagueDetailModel: self.leagueDetailModel,
//                teamOneModel: self.teamOnePlayersController,
//                teamTwoModel: self.teamTwoPlayersController,
//                refereesModel: self.refereesController, // TODO: Don't need anymore
//                eventsModel: self.eventsController
//            )
//        default:
//            break
//        }
    }
    
    func prepareSegueDataModel(destination: UIViewController) {
        switch destination {
        case is EditTeamProtocolTableViewController:
            let controller = destination as! EditTeamProtocolTableViewController
            controller.playersController = teamOnePlayersController
//            controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.league, match: match, team: .one)
//            controller.saveProtocol = self
        case is EditRefereeTeamTableViewController:
            let controller = destination as! EditRefereeTeamTableViewController
            controller.refereesController = self.refereesController
            controller.match = self.match
        case is EditEventsMatchTableViewController:
            let controller = destination as! EditEventsMatchTableViewController
            controller.eventsController = eventsController
//            controller.model = self.model
            controller.teamOneController = self.teamOnePlayersController
            controller.teamTwoController = self.teamTwoPlayersController
        case is EditScoreMatchTableViewController:
            let controller = destination as! EditScoreMatchTableViewController
//            controller.viewModel = RefereeScoreModel(
//                match: self.match,
//                leagueDetailModel: self.leagueDetailModel,
//                teamOnePlayers: self.teamOnePlayersController,
//                teamTwoPlayers: self.teamTwoPlayersController,
//                events: self.eventsController
//            )
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController, team: TeamEnum) {
        switch destination {
        case is EditTeamProtocolTableViewController:
            let controller = destination as! EditTeamProtocolTableViewController
            
            switch team{
            case .one:
                controller.playersController = teamOnePlayersController
//                controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.league, match: match, team: .one)
                controller.saveProtocol = self
            case .two:
                controller.playersController = teamTwoPlayersController
//                controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.league, match: match, team: .two)
                controller.saveProtocol = self
            }
        default:
            break
        }
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
