//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import AlamofireImage

class ScheduleTableViewController: UITableViewController {

    let cellId = "cell_schedule"
    
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    let presenter = ScheduleLeaguePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        updateUI()
        
//        try! debugPrint(leagueDetailModel.league.jsonString())
//        try! debugPrint(leagueDetailModel.leagueInfo.jsonString())
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}

extension ScheduleTableViewController: ScheduleLeagueView {
    func onGetClubSuccess(club: Clubs) {
        
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
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
        
        presenter.getClubImage(id: match.teamOne) { (image) in
            cell.mImageTeam1.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: match.teamTwo) { (image) in
            cell.mImageTeam2.image = image.af_imageRoundedIntoCircle()
        }
        
        //cell.mImageTeam1.af_setImage(withURL: ApiRoute.getImageURL(image: ))
        //print(title1 ?? "some error")
        //cell?.mTitleTeam1.text = leagueInfo.league.teams[]
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
