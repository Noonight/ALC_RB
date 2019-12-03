//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditMatchProtocolViewController: UIViewController {
    enum SegueIdentifiers {
        static let DO_MATCH = "segue_do_match_referee"
        static let TEAM_ONE = "team_one_protocol_segue"
        static let TEAM_TWO = "team_two_protocol_segue"
        static let REFEREES = "referee_protocol_segue"
        static let EVENTS   = "events_protocol_segue"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    
    @IBOutlet weak var teamOneBtn: UIButton!
    @IBOutlet weak var teamTwoBtn: UIButton!
    @IBOutlet weak var refereesBtn: UIButton!
    @IBOutlet weak var eventsBtn: UIButton!
    
    @IBOutlet weak var height_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var scoreBarBtn: UIBarButtonItem!
    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    
    // MARK: Var & Let
    
    var leagueDetailModel = LeagueDetailModel()
    var match = Match()
//    var model: MyMatchesRefTableViewCell.CellModel!
    
    let presenter = EditMatchProtocolPresenter()
    
    let userDefaults = UserDefaultsHelper()
    
    // MARK: - Model Controllers
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupNavController()
        self.setupView()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unSetupNavigationcontroller()
    }
    
    // MARK: Setup
    
    func setupPresenter() {
        self.initPresenter()
    }
    
    func setupView() {
        
//        teamOneTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.league, match: match, team: .one)
//
//        teamTwoTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.league, match: match, team: .two)
//
//        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamOne!, league: leagueDetailModel.league)) { (image) in
//            self.teamOneLogo.image = image.af_imageRoundedIntoCircle()
//        }
//        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamTwo!, league: leagueDetailModel.league)) { (image) in
//            self.teamTwoLogo.image = image.af_imageRoundedIntoCircle()
//        }
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
    
    // MARK: Un-setup
    
    func unSetupNavigationcontroller() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
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

// MARK: Extensions

// MARK: Helpers

extension EditMatchProtocolViewController {
    
    func connectPlayersOfTeamOneAndTwo() -> [Person] {
        return [teamOnePlayersController.getPlayingPlayers(), teamTwoPlayersController.getPlayingPlayers()].flatMap({ liPlayer -> [Person] in
            return liPlayer
        })
    }
    
//    func getPlayersTeam(team id: String) -> [Person] {
//        return (leagueDetailModel.league.teams?.filter({ (team) -> Bool in
//            return team.id == id
//        }).first?.players)!
//    }
    
//    func getMatchPlayers(team id: String) -> [Person] {
//        let teamPlayers = (leagueDetailModel.league.teams?.filter({ team -> Bool in
//            return team.id == id
//        }).first?.players!)!
//        var players = [Person]()
//        for teamPlayer in teamPlayers {
//            for playerId in match.playersList! {
//                if teamPlayer.playerId == playerId {
//                    players.append(teamPlayer)
//                }
//            }
//        }
//        return players
//    }
    
}

// MARK: Actions

extension EditMatchProtocolViewController {
    @IBAction func scoreBtnPressed(_ sender: UIBarButtonItem) {
        let score: EditScoreMatchTableViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "EditScoreMatchTableViewController") as! EditScoreMatchTableViewController
            
//            controller.viewModel = RefereeScoreModel(
//                match: self.match,
//                leagueDetailModel: self.leagueDetailModel,
//                teamOnePlayers: self.teamOnePlayersController,
//                teamTwoPlayers: self.teamTwoPlayersController,
//                events: self.eventsController
//            )
            
            return controller
        }()
        navigationController?.show(score, sender: self)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        
//        showAlertOkCancel(title: "Сохранить протокол?", message: "", ok: {
//            let request = EditProtocol(
//                id: self.match.id,
//                events: EditProtocol.Events(events: self.eventsController.events),
//                playersList: self.connectPlayersOfTeamOneAndTwo().map({ liPlayer -> String in
//                    return liPlayer.playerId
//                })
//            )
//            self.presenter.requestEditProtocol(
//                token: (self.userDefaults.getAuthorizedUser()?.token)!,
//                editProtocol: request
//            )
//        }) {
//            Print.m("Отмена сохранения протокола")
//        }
        
    }
    
    @IBAction func teamOneBtnPressed(_ sender: UIButton) { }
    @IBAction func teamTwoBtnPressed(_ sender: UIButton) { }
    @IBAction func refereeBtnPressed(_ sender: UIButton) { }
    @IBAction func eventsBtnPressed(_ sender: UIButton) { }
}

// MARK: Navigation

extension EditMatchProtocolViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.TEAM_ONE:
            prepareSegueDataModel(destination: segue.destination, team: .one)
        case SegueIdentifiers.TEAM_TWO:
            prepareSegueDataModel(destination: segue.destination, team: .two)
        case SegueIdentifiers.REFEREES:
            prepareSegueDataModel(destination: segue.destination)
        case SegueIdentifiers.EVENTS:
            prepareSegueDataModel(destination: segue.destination)
        case SegueIdentifiers.DO_MATCH:
            let controller = segue.destination as! DoMatchProtocolRefereeViewController
            controller.viewModel = ProtocolRefereeViewModel(
                match: self.match,
                leagueDetailModel: self.leagueDetailModel,
                teamOneModel: self.teamOnePlayersController,
                teamTwoModel: self.teamTwoPlayersController,
                refereesModel: self.refereesController,
                eventsModel: self.eventsController
            )
        default:
            break
        }
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
        var user = userDefaults.getAuthorizedUser()
//        user?.person.participationMatches?.removeAll(where: { $0.isEqual({ $0.id == match.match?.id }) })
//        user?.person.participationMatches!.removeAll(where: { pMatch -> Bool in
//            return pMatch.id == match.match?.id
//        })
//        user?.person.participationMatches!.append(IdRefObjectWrapper(match.match!))
        self.userDefaults.setAuthorizedUser(user: user!)
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
