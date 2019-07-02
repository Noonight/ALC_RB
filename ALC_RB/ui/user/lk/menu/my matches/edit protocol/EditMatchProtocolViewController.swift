//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditMatchProtocolViewController: UIViewController {

    // MARK: - Variables
    
    let segueOneId = "team_one_protocol_segue"
    let segueTwoId = "team_two_protocol_segue"
    let segueReferee = "referee_protocol_segue"
    let segueEvents = "events_protocol_segue"
    
    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    
    @IBOutlet weak var teamOneBtn: UIButton!
    @IBOutlet weak var teamTwoBtn: UIButton!
    @IBOutlet weak var refereesBtn: UIButton!
    @IBOutlet weak var eventsBtn: UIButton!
    
    var leagueDetailModel = LeagueDetailModel()
    var match = LIMatch()
    
    let presenter = EditMatchProtocolPresenter()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.topItem?.title = " "
        title = "Протокол"
        
        teamOneTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .one)
        
        teamTwoTitle.text = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .two)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamOne!, league: leagueDetailModel.leagueInfo.league)) { (image) in
            self.teamOneLogo.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(match.teamTwo!, league: leagueDetailModel.leagueInfo.league)) { (image) in
            self.teamTwoLogo.image = image.af_imageRoundedIntoCircle()
        }
        
        let navigationMatchScoreBtn = UIBarButtonItem(title: "Счет", style: .plain, target: self, action: #selector(onMatchScoreBtnPressed(sender:)))
        navigationItem.rightBarButtonItem = navigationMatchScoreBtn
    }
    
    // MARK: - Button Actions
    
    @objc func onMatchScoreBtnPressed(sender: UIBarButtonItem) {
        let score: EditScoreMatchTableViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "EditScoreMatchTableViewController") as! EditScoreMatchTableViewController
            controller.leagueDetailModel = self.leagueDetailModel
            controller.match = self.match
            return controller
        }()
        navigationController?.show(score, sender: self)
    }
    
    @IBAction func teamOneBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func teamTwoBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func refereeBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func eventsBtnPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueOneId:
            //let destination = segue.destination as?  TeamProtocolTableViewController
            prepareSegueDataModel(destination: segue.destination, team: .one)
        case segueTwoId:
            prepareSegueDataModel(destination: segue.destination, team: .two)
        case segueReferee:
            prepareSegueDataModel(destination: segue.destination)
        case segueEvents:
            prepareSegueDataModel(destination: segue.destination)
            break
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController) {
        switch destination {
        case is EditTeamProtocolTableViewController:
            let controller = destination as! EditTeamProtocolTableViewController
            controller.players = getPlayersTeam(team: match.teamOne!)
            controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .one)
        case is EditRefereeTeamTableViewController:
            let controller = destination as! EditRefereeTeamTableViewController
            controller.destinationData = match.referees
        case is EditEventsMatchTableViewController:
            let controller = destination as! EditEventsMatchTableViewController
            controller.destinationModel = match.events
        case is EditScoreMatchTableViewController:
            let controller = destination as! EditScoreMatchTableViewController
            controller.leagueDetailModel = leagueDetailModel
            controller.match = match
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController, team: ClubTeamHelper.TeamEnum) {
        switch destination {
        case is EditTeamProtocolTableViewController:
            let controller = destination as! EditTeamProtocolTableViewController
            switch team {
            case .one:
                controller.players = getPlayersTeam(team: match.teamOne!)
                controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .one)
            case .two:
                controller.players = getPlayersTeam(team: match.teamTwo!)
                controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .two)
            }
        default:
            break
        }
    }
    
    func getPlayersTeam(team id: String) -> [LIPlayer] {
        return (leagueDetailModel.leagueInfo.league.teams?.filter({ (team) -> Bool in
            return team.id == id
        }).first?.players)!
    }
}

extension EditMatchProtocolViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
