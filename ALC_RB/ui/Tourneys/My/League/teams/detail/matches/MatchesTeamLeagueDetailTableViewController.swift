//
//  MatchesTeamLeagueDetailTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 18.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchesTeamLeagueDetailTableViewController: UITableViewController {

    let cellId = "cell_team_match"
    
    //var leagueDetailModel: LeagueDetailModel = LeagueDetailModel()
    var team = LITeam()
    var matches = [LIMatch]()
    var league = LILeague()
    
    let presenter = MatchesTeamLeagueDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
}

extension MatchesTeamLeagueDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MatchesTeamLeagueDetailTableViewCell
        let match = matches[indexPath.row]
        
        configureCell(cell: cell, match: match, league: league)
        
        return cell
    }
    
    func configureCell(cell: MatchesTeamLeagueDetailTableViewCell, match: LIMatch, league: LILeague) {
        cell.mDate.text = match.date?.toFormat(DateFormats.local.rawValue)//.convertDate(from: .utc, to: .local)
        cell.mTime.text = match.date?.toFormat(DateFormats.localTime.rawValue)//.convertDate(from: .utcTime, to: .localTime)
        cell.mTour.text = match.tour
        cell.mPlace.text = match.place
        
        cell.mTitleTeam1.text = getTeamTitle(league: league, match: match, team: .one)
        cell.mTitleTeam2.text = getTeamTitle(league: league, match: match, team: .two)
        cell.mScore.text = match.score ?? "-"
        
        if let teamOne = match.teamOne {
            presenter.getClubImage(id: getClubIdByTeamId(teamOne, league: league)) { (image) in
                cell.mImageTeam1.image = image.af_imageRoundedIntoCircle()
            }
        }
        
        if let teamTwo = match.teamTwo {
            presenter.getClubImage(id: getClubIdByTeamId(teamTwo, league: league)) { (image) in
                cell.mImageTeam2.image = image.af_imageRoundedIntoCircle()
            }
        }
    }
    
    func getClubIdByTeamId(_ teamId: String, league: LILeague) -> String {
        return league.teams?.filter({ (team) -> Bool in
            return team.id == teamId
        }).first?.id ?? "club id \n not found"
    }
    
    func getTeamTitle(league: LILeague, match: LIMatch, team: TeamEnum) -> String {
        switch team {
        case .one:
            return league.teams?.filter({ (team) -> Bool in
                return team.id == match.teamOne
            }).first?.name ?? "Team name \n one not found"
        case .two:
            return league.teams?.filter({ (team) -> Bool in
                return team.id == match.teamTwo
            }).first?.name ?? "Team name \n two not found"
        }
    }
    
    enum TeamEnum: Int {
        case one = 1
        case two = 2
    }
}

extension MatchesTeamLeagueDetailTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MatchesTeamLeagueDetailTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}


