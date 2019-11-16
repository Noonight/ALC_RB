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
    
    @IBOutlet weak var main_time_label: UILabel!
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
    
//    var leagueDetailModel = LeagueDetailModel()
//    var match = Match()

    var viewModel: ProtocolAllViewModel!
    var eventsTable: ProtocolTableEvents = ProtocolTableEvents()
    
    let presenter = MatchProtocolPresenter()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setupNavBarRightTour()
        self.setupView()
        self.setupTitle()
        self.setupTableDataSource()
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension MatchProtocolViewController {
    
    func setupTableView() {
        self.events_table_view.dataSource   = self.eventsTable
        self.events_table_view.delegate     = self.eventsTable
    }
    
    func setupTableDataSource() {
//        let hud = self.events_table_view.showLoadingViewHUD(with: "Настройка...") // TODO
//        let hud = self.events_table_view.backgroundView?.showLoadingViewHUD(with: "Настройка...")
        hud = self.events_table_view.showLoadingViewHUD(with: "Настройка...")
        self.viewModel.prepareTableViewDataSource { dataSource in
            self.eventsTable.dataSource = dataSource
            self.events_table_view.reloadData()
            self.hud?.hide(animated: true)
        }
    }
    
    func setupView() {
        
        let hud = showLoadingViewHUD(with: "Настройка...")
        
        self.team_one_label.text = self.viewModel.prepareTeamTitle(team: .one)
        self.team_two_label.text = self.viewModel.prepareTeamTitle(team: .two)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(self.viewModel.match.teamOne!, league: self.viewModel.leagueDetailModel.league)) { (image) in
            self.team_one_image.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(self.viewModel.match.teamTwo!, league: self.viewModel.leagueDetailModel.league)) { (image) in
            self.team_two_image.image = image.af_imageRoundedIntoCircle()
        }
        
        self.tournament_name_label.text = self.viewModel.prepareTournamentTitle()
        self.date_label.text = self.viewModel.prepareDate()
        self.day_of_week_label.text = self.viewModel.prepareDateAsWeekDay()
        self.time_label.text = self.viewModel.prepareTime()
        self.place_label.text = self.viewModel.preparePlace()
        
        self.match_state_time_label.text = self.viewModel.prepareEndOfMatch()
//        self.result_score_label.text = self.viewModel.prepareResultScore() TODO for feature score counted from server
        self.result_score_label.text = self.viewModel.prepareResultScoreCalculated() // TODO CHANGE IT LATER
        if self.viewModel.prepareEndOfMatch().contains("в основное время")
        {
            self.main_time_label.text = ""
            self.score_in_main_time_label.text = ""
        }
        else
        {
            
            self.score_in_main_time_label.text = self.viewModel.prepareMainTimeScore()
        }
        self.score_in_first_time_label.text = self.viewModel.prepareFirstTimeScore()
        
        if self.viewModel.hasPenaltySeriesEvents() == true {
            self.penalty_series_label.isHidden = false
            self.score_in_penalty_series_label.isHidden = false
            
            self.score_in_penalty_series_label.text = self.viewModel.preparePenaltyScore()
        } else {
            self.penalty_series_label.isHidden = true
            self.score_in_penalty_series_label.isHidden = true
        }
        
        
        self.teamOneTitle.text = self.viewModel.prepareTeamTitle(team: .one)
        self.teamTwoTitle.text = self.viewModel.prepareTeamTitle(team: .two)
        
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(self.viewModel.match.teamOne!, league: self.viewModel.leagueDetailModel.league)) { (image) in
            self.teamOneLogo.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: ClubTeamHelper.getClubIdByTeamId(self.viewModel.match.teamTwo!, league: self.viewModel.leagueDetailModel.league)) { (image) in
            self.teamTwoLogo.image = image.af_imageRoundedIntoCircle()
        }
        
        hud.hide(animated: false)
    }
    
    func setupTitle() {
        navigationController?.navigationBar.topItem?.title = " "
        title = ""
    }
    
    func setupNavBarRightTour() {
        let navigationMatchScoreBtn = UIBarButtonItem(title: self.viewModel.prepareTour(), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = navigationMatchScoreBtn
    }
    
    func setupPresenter() {
        self.initPresenter()
    }
    
}

// MARK: ACTIONS

extension MatchProtocolViewController {
    
    @IBAction func onTeamOneTap(_ sender: UITapGestureRecognizer) {
        
    }
    @IBAction func onTeamTwoTap(_ sender: UITapGestureRecognizer) {
        
    }
    @objc func onMatchScoreBtnPressed(sender: UIBarButtonItem) {
//        let score: ScoreMatchTableViewController = {
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//            let controller = storyboard.instantiateViewController(withIdentifier: "ScoreMatchTableViewController") as! ScoreMatchTableViewController
//            controller.leagueDetailModel = self.viewModel.leagueDetailModel
//            controller.match = self.viewModel.match
//            return controller
//        }()
//        navigationController?.show(score, sender: self)
    }
    
    @IBAction func teamOneBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func teamTwoBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func refereeBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func eventsBtnPressed(_ sender: UIButton) {
        
    }
}

// MARK: HELPERS

extension MatchProtocolViewController {
    func getPlayersTeam(team id: String) -> [DEPRECATED] {
        return (self.viewModel.leagueDetailModel.league.teams?.filter({ (team) -> Bool in
            return team.id == id
        }).first?.players)!
    }
}

// MARK: PRESENTER

extension MatchProtocolViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: NAVIGATION

extension MatchProtocolViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.TEAM_ONE:
            //let destination = segue.destination as?  TeamProtocolTableViewController
            prepareSegueDataModel(destination: segue.destination, team: .one)
        case SegueIdentifiers.TEAM_TWO:
            prepareSegueDataModel(destination: segue.destination, team: .two)
        case SegueIdentifiers.REFEREES:
            prepareSegueDataModel(destination: segue.destination)
            //        case segueEvents:
            //            prepareSegueDataModel(destination: segue.destination)
        //            break
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController) {
        switch destination {
        case is TeamProtocolTableViewController:
            let controller = destination as! TeamProtocolTableViewController
            controller.players = getPlayersTeam(team: self.viewModel.match.teamOne!)
            controller.title = ClubTeamHelper.getTeamTitle(league: self.viewModel.leagueDetailModel.league, match: self.viewModel.match, team: .one)
        case is RefereeTeamTableViewController:
            let controller = destination as! RefereeTeamTableViewController
            controller.destinationData = self.viewModel.match.referees
        case is EventsMatchTableViewController:
            let controller = destination as! EventsMatchTableViewController
            controller.destinationModel = self.viewModel.match.events
        case is ScoreMatchTableViewController:
            let controller = destination as! ScoreMatchTableViewController
            controller.leagueDetailModel = self.viewModel.leagueDetailModel
            controller.match = self.viewModel.match
        default:
            break
        }
    }
    
    func prepareSegueDataModel(destination: UIViewController, team: TeamEnum) {
        switch destination {
        case is TeamProtocolTableViewController:
            let controller = destination as! TeamProtocolTableViewController
            switch team {
            case .one:
                controller.players = getPlayersTeam(team: self.viewModel.match.teamOne!)
                controller.title = ClubTeamHelper.getTeamTitle(league: self.viewModel.leagueDetailModel.league, match: self.viewModel.match, team: .one)
            case .two:
                controller.players = getPlayersTeam(team: self.viewModel.match.teamTwo!)
                controller.title = ClubTeamHelper.getTeamTitle(league: self.viewModel.leagueDetailModel.league, match: self.viewModel.match, team: .two)
            }
        default:
            break
        }
    }
    
}
