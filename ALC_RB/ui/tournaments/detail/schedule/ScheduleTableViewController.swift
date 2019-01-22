//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift

class ScheduleTableViewController: UITableViewController {

    let cellId = "cell_schedule"
    
    let presenter = ScheduleLeaguePresenter()
    
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    @IBOutlet var empty_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        initView()
        
        //updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //updateUI()
    }
    
    func initView() {
        //showLoading()
        //title = " "
    }
    
    func leagueInfoMatchesIsEmpty() -> Bool {
        //debugPrint(leagueDetailModel.leagueInfo.league.matches)
        print (leagueDetailModel.leagueInfo.league.matches.isEmpty ? " League matches is empty --- " : " League matches not empty +++ ")
        if leagueDetailModel.league.matches.count > 0 {
            return false
        } else {
            return true
        }
        //return leagueDetailModel.leagueInfo.league.matches.isEmpty
    }
    
    func checkEmptyView() {
        //hideLoading()
        if leagueInfoMatchesIsEmpty() {
            showEmptyView()
        } else {
            hideEmptyView()
            
            tableView.reloadData()
        }
    }
    
    func updateUI() {
        debugPrint(#function)
        checkEmptyView()
    }
}

extension ScheduleTableViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
        print(#function)
        updateUI()
    }
}

extension ScheduleTableViewController: ScheduleLeagueView {
    func onGetClubSuccess(club: Clubs) {
        
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
    }
}

extension ScheduleTableViewController: ActivityIndicatorProtocol {
    func showLoading() {
        tableView.backgroundView = activityIndicator
        tableView.separatorStyle = .none
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
    }
}

extension ScheduleTableViewController: EmptyProtocol {
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
    }
    
    func showEmptyView() {
        tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        tableView.backgroundView?.addSubview(empty_view)
        empty_view.setCenterFromParent()

        tableView.separatorStyle = .none
    }
}

extension ScheduleTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension ScheduleTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueDetailModel.leagueInfo.league.matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ScheduleTableViewCell
        
        let model = leagueDetailModel.leagueInfo.league
        let match = leagueDetailModel.leagueInfo.league.matches[indexPath.row]
        
        configureCell(cell, model, match)
        
        return cell
    }
    
    func configureCell(_ cell: ScheduleTableViewCell, _ model: LILeague, _ match: LIMatch) {
        
        if match.played {
            cell.accessoryType = .disclosureIndicator
            //cell.selectionStyle = .default
        } else {
            cell.accessoryType = .none
            //cell.selectionStyle = .none
        }
        
        //debugPrint(model.matches)
        cell.mDate.text = match.date.UTCToLocal(from: .utc, to: .local)
        cell.mTime.text = match.date.UTCToLocal(from: .utcTime, to: .localTime)
        cell.mTour.text = match.tour
        cell.mPlace.text = match.place

//        let title1 = model.teams.filter { i -> Bool in
//            i.id == model.matches[indexPath.row].teamOne
//            }.first?.club
        
        cell.mTitleTeam1.text = getTeamTitle(league: model, match: match, team: .one)
        cell.mTitleTeam2.text = getTeamTitle(league: model, match: match, team: .two)
        cell.mScore.text = match.score ?? "-"
//
//        presenter.getClubImage(id: match.teamOne) { (image) in
//            cell.mImageTeam1.image = image.af_imageRoundedIntoCircle()
//        }
//        presenter.getClubImage(id: match.teamTwo) { (image) in
//            cell.mImageTeam2.image = image.af_imageRoundedIntoCircle()
//        }
        
        presenter.getClubImage(id: getClubIdByTeamId(match.teamOne, league: model)) { (image) in
            cell.mImageTeam1.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: getClubIdByTeamId(match.teamTwo, league: model)) { (image) in
            cell.mImageTeam2.image = image.af_imageRoundedIntoCircle()
        }
        
        presenter.getClubs(id: <#T##String#>, getting: <#T##(Clubs) -> ()#>)
        
        debugPrint("\(getClubIdByTeamId(match.teamOne, league: model)) ----------------------")
    }
    
    func getClubIdByTeamId(_ teamId: String, league: LILeague) -> String {
        return league.teams.filter({ (team) -> Bool in
            return team.id == teamId
        }).first?.id ?? "club id \n not found"
    }
    
    func getTeamTitle(league: LILeague, match: LIMatch, team: TeamEnum) -> String {
        switch team {
        case .one:
            return league.teams.filter({ (team) -> Bool in
                return team.id == match.teamOne
            }).first?.name ?? "Team name \n one not found"
        case .two:
            return league.teams.filter({ (team) -> Bool in
                return team.id == match.teamTwo
            }).first?.name ?? "Team name \n two not found"
        }
    }
    
    enum TeamEnum: Int {
        case one = 1
        case two = 2
    }
}

extension ScheduleTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if leagueDetailModel.leagueInfo.league.matches[indexPath.row].played {
//
//        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if leagueDetailModel.leagueInfo.league.matches[indexPath.row].played {
            return indexPath
        }
        return nil
    }
}
