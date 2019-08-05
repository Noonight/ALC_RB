//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchProtocolViewController: UIViewController {
    enum SegueIdentifiers {
        static let TEAM_ONE = "team_one_protocol_segue"
        static let TEAM_TWO = "team_two_protocol_segue"
        static let REFEREES = "referee_protocol_segue"
    }
    
    // MAKR: OUTLETS
    
    @IBOutlet weak var tournament_name_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var day_of_week_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var place_label: UILabel!
    
    @IBOutlet weak var match_state_label: UILabel! // status of match
    @IBOutlet weak var match_state_time_label: UILabel! // time of end match
    
    @IBOutlet weak var result_score_label: UILabel!
    
    @IBOutlet weak var team_one_label: UILabel!
    @IBOutlet weak var team_two_label: UILabel!
    @IBOutlet weak var team_one_image: UIImageView!
    @IBOutlet weak var team_two_image: UIImageView!
    
    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    
    @IBOutlet weak var score_in_main_time_label: UILabel! // 3 : 3
    @IBOutlet weak var score_in_first_time_label: UILabel! // (1 : 2) example
    @IBOutlet weak var penalty_series_label: UILabel! // enable or not only
    @IBOutlet weak var score_in_penalty_series_label: UILabel! // 3 : 2
    
    @IBOutlet weak var events_table_view: IntrinsicTableView!
    
    @IBOutlet weak var teamOneBtn: UIButton!
    @IBOutlet weak var teamTwoBtn: UIButton!
    @IBOutlet weak var refereesBtn: UIButton!
    
    @IBOutlet var teamOneTap: UITapGestureRecognizer!
    @IBOutlet var teamTwoTap: UITapGestureRecognizer!
    
    // MARK: VAR & LET
    
    var leagueDetailModel = LeagueDetailModel()
    var match = LIMatch()
    
    let presenter = MatchProtocolPresenter()
    
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
    
    @IBAction func onTeamOneTap(_ sender: UITapGestureRecognizer) {
        
    }
    @IBAction func onTeamTwoTap(_ sender: UITapGestureRecognizer) {
        
    }
    @objc func onMatchScoreBtnPressed(sender: UIBarButtonItem) {
        let score: ScoreMatchTableViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "ScoreMatchTableViewController") as! ScoreMatchTableViewController
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
        case is TeamProtocolTableViewController:
            let controller = destination as! TeamProtocolTableViewController
            controller.players = getPlayersTeam(team: match.teamOne!)
            controller.title = ClubTeamHelper.getTeamTitle(league: leagueDetailModel.leagueInfo.league, match: match, team: .one)
        case is RefereeTeamTableViewController:
            let controller = destination as! RefereeTeamTableViewController
            controller.destinationData = match.referees
        case is EventsMatchTableViewController:
            let controller = destination as! EventsMatchTableViewController
            controller.destinationModel = match.events
        case is ScoreMatchTableViewController:
            let controller = destination as! ScoreMatchTableViewController
            controller.leagueDetailModel = leagueDetailModel
            controller.match = match
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController, team: ClubTeamHelper.TeamEnum) {
        switch destination {
        case is TeamProtocolTableViewController:
            let controller = destination as! TeamProtocolTableViewController
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

extension MatchProtocolViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
