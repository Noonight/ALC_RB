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
    
    static func getInstance(match: Match, callBack: EditMatchProtocolCallBack) -> EditMatchProtocolViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditMatchProtocolViewControllerProtocol") as! EditMatchProtocolViewController
        
        viewController.presenter.match = match
        viewController.back = callBack
        
        return viewController
    }
    
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
    
    func setupView() {
        
        teamOneTitle.text = self.presenter.match.teamOne?.getValue()?.name ?? "Не назначена"
        teamTwoTitle.text = self.presenter.match.teamTwo?.getValue()?.name ?? "Не назначена"
        
        refereesBtn.indicatorViewStyle = true
        workProtocolBtn.indicatorViewStyle = true
        
        teamOneBtn.stopLoading()
        teamTwoBtn.stopLoading()
        refereesBtn.stopLoading()
        workProtocolBtn.stopLoading()
        
        if presenter.match.teamOne != nil {
            self.teamOneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamOnePressed(_:))))
            teamOneBtn.indicatorViewStyle = true
        } else {
            self.teamOneView.gestureRecognizers?.removeAll()
        }
        if presenter.match.teamTwo != nil {
            self.teamTwoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(teamTwoPressed(_:))))
            teamTwoBtn.indicatorViewStyle = true
        } else {
            self.teamTwoView.gestureRecognizers?.removeAll()
        }
        
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
        self.fetchShowTeamPlayers(team: .one) {
            self.teamOneBtn.stopLoading()
        }
    }
    
    @objc func teamTwoPressed(_ sender: UIView) {
        Print.m("TEAM TWO")
        teamTwoBtn.startLoading()
        self.fetchShowTeamPlayers(team: .two) {
            self.teamTwoBtn.stopLoading()
        }
    }
    
    @objc func refereesPressed(_ sender: UIView) {
        Print.m("REFEREES")
        self.showEditReferees()
    }
    
    @objc func doMatchPressed(_ sender: UIButton) {
        Print.m("WORK PROTOCOL")
//        workProtocolBtn.startLoading()
//        self.showAlert(message: "Рабочий протокол")
        self.showWorkProtocol()
    }
    
}

// MARK: - HELPERS

extension EditMatchProtocolViewController {
    
    func fetchShowTeamPlayers(team: TeamEnum, closure: @escaping () -> ()) {
        self.presenter.fetchTeamPlayers(team: team) { result in
            switch result {
            case .success(let fetchedTeam):
                
                self.showEditTeamPlayers(match: self.presenter.match, team: fetchedTeam)
                
                closure()
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
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
        if navigationController?.viewControllers.last is EditTeamProtocolPlayersVC {
            navigationController?.popViewController(animated: true)
        }
        self.presenter.fetchMatchPlayers()
    }
}

// MARK: - AssignRefereesCallBack

extension EditMatchProtocolViewController: AssignRefereesCallBack {
    func assignRefereesBack(match: Match) {
        if navigationController?.viewControllers.last is AssignRefereesVC {
            navigationController?.popViewController(animated: true)
        }
        self.presenter.fetchMatchReferees()
    }
}

// MARK: - NAVIGATION

extension EditMatchProtocolViewController {
    
    func showEditTeamPlayers(match: Match, team: Team) {
        
        let vc = EditTeamProtocolPlayersVC.getInstance()
//        vc.viewModel = EditTeamProtocolViewModel(matchApi: MatchApi())
        vc.viewModel.match = BehaviorRelay<Match?>(value: match)
        vc.viewModel.team = BehaviorRelay<Team?>(value: team)
        vc.back = self
        
        self.show(vc, sender: self)
    }
    
    func showEditReferees() {
        let vc = AssignRefereesVC.getInstance(kind: .editMatchProtocol, match: self.presenter.match, callBack: self)
        
        self.show(vc, sender: self)
    }
    
    func showWorkProtocol() {
        
        workProtocolBtn.startLoading()
        
        let group = DispatchGroup()
        
        let leagueApi = LeagueApi()
        let params = ParamBuilder<League.CodingKeys>()
            .add(key: .id, value: self.presenter.match.league?.getId() ?? self.presenter.match.league?.getValue()?.id)
            .populate(.tourney)
            .get()
        group.enter()
        leagueApi.get_league(params: params) { result in
            switch result {
            case .success(let fetchedLeague):
                
                self.presenter.match.league = IdRefObjectWrapper<League>(fetchedLeague.first!)
                
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            group.leave()
        }
        group.enter()
        self.presenter.fetchMatchPlayers() {
            group.leave()
        }
        group.enter()
        self.presenter.fetchTeamPlayers(team: .one) { result in
            switch result {
            case .success(let fetchedTeam):
                self.presenter.match.teamOne = IdRefObjectWrapper<Team>(fetchedTeam)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            group.leave()
        }
        group.enter()
        self.presenter.fetchTeamPlayers(team: .two) { result in
            switch result {
            case .success(let fetchedTeam):
                self.presenter.match.teamTwo = IdRefObjectWrapper<Team>(fetchedTeam)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            self.workProtocolBtn.stopLoading()
            
//            let teamOnePersons = self.presenter.match.teamOne?.getValue()?.players?.map({ player -> Person in
//                return (player.person?.getValue())!
//            }) ?? []
//            let teamTwoPersons = self.presenter.match.teamTwo?.getValue()?.players?.map({ player -> Person in
//                return (player.person?.getValue())!
//            }) ?? []
//            let matchPersons = self.presenter.match.playersList?.map({ personObj -> Person in
//                return personObj.getValue()!
//            }) ?? []
            
//            let vm = ProtocolRefereeViewModel(
//                match: self.presenter.match,
//                leagueDetailModel: LeagueDetailModel(tourney: (self.presenter.match.league?.getValue()?.tourney?.getValue()!)!, league: (self.presenter.match.league?.getValue()!)!),
//                teamOneModel: ProtocolPlayersController(teamPlayers: teamOnePersons, matchPlayers: matchPersons),
//                teamTwoModel: ProtocolPlayersController(teamPlayers: teamTwoPersons, matchPlayers: matchPersons),
//                eventsModel: ProtocolEventsController(events: self.presenter.match.events!))
//            let vc = DoMatchProtocolRefereeViewController.getInstance(viewModel: vm)
            let vc = WorkProtocolVC.getInstance(match: self.presenter.match)
            
            self.show(vc, sender: self)
        }
        
        
    }
    
}
