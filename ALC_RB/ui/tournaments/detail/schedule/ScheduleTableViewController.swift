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
    enum CellIdentifiers {
        static let CELL = "cell_schedule"
    }
    enum SegueIdentifiers {
        static let DETAIL = "segue_schedule_protocol"
    }
    
    let presenter = ScheduleLeaguePresenter()
    
    var _leagueDetailModel = LeagueDetailModel()
    var leagueDetailModel: LeagueDetailModel
    {
        get {
            return _leagueDetailModel
        }
        set {
            if newValue.leagueInfo.league.matches?.count != 0
            {
                var newVal = newValue
                let hud = self.tableView.showLoadingViewHUD(with: "Сортируем по дате...")
                if let curMatches = newVal.leagueInfo.league.matches {
                    
                    let sortedMatches = SortMatchesByDateHelper.sort(type: .lowToHigh, matches: curMatches) // sorting matches by date
                    newVal.leagueInfo.league.matches = sortedMatches
                }
                _leagueDetailModel = newVal
                hud.showSuccessAfterAndHideAfter(withMessage: "Готово")
                self.updateUI()
            }
            else
            {
                self.updateUI()
            }
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    var backgroundView = UIView()
    
    @IBOutlet var empty_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        initPresenter()
    }
    
    func leagueInfoMatchesIsEmpty() -> Bool {

        if leagueDetailModel.league.matches!.count > 0 {
            return false
        } else {
            return true
        }
    }
    
    func checkEmptyView() {
        if leagueInfoMatchesIsEmpty() {
            showEmptyView()
        } else {
            hideEmptyView()
            
            tableView.reloadData()
        }
    }
    
    func updateUI() {
        checkEmptyView()
    }
}

// MARK: Extensions

// MARK: LeagueMainProtocol

extension ScheduleTableViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
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
        backgroundView.removeFromSuperview()
    }
    
    func showEmptyView() {
        
        let newEmptyView = EmptyViewNew()
        
        backgroundView.frame = tableView.frame
        
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(newEmptyView)
        
        tableView.addSubview(backgroundView)
        
        newEmptyView.setText(text: "Здесь будут отображаться матчи")
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        
        newEmptyView.setCenterFromParent()
        newEmptyView.containerView.setCenterFromParent()
        
        backgroundView.setCenterFromParent()
        
        tableView.bringSubviewToFront(backgroundView)

        tableView.separatorStyle = .none
    }
}

// MARK: NAVIGATION

extension ScheduleTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.DETAIL,
            let destination = segue.destination as? MatchProtocolViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.leagueDetailModel = self.leagueDetailModel
            destination.match = self.leagueDetailModel.leagueInfo.league.matches![cellIndex]
        }
    }
}

// MARK: TABLE VIEW: DATASOURCE

extension ScheduleTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (leagueDetailModel.leagueInfo.league.matches?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CELL, for: indexPath) as! ScheduleTableViewCell
        
        let model = leagueDetailModel.leagueInfo.league
        let match = (leagueDetailModel.leagueInfo.league.matches?[indexPath.row])!
        
        configureCell(cell, model, match)
        
        return cell
    }
    
    func configureCell(_ cell: ScheduleTableViewCell, _ model: LILeague, _ match: LIMatch) {
        
        if match.played == true {
            cell.accessoryType = .disclosureIndicator
            cell.setColorState(played: true)
        } else {
            cell.accessoryType = .none
            cell.setColorState(played: false)
        }
        
        if match.date?.count ?? 0 > 2
        {
            cell.mDate.text = match.date?.toDate()?.toFormat(DateFormats.local.rawValue)
            cell.mTime.text = match.date?.toDate()?.toFormat(DateFormats.localTime.rawValue)
        }
        else
        {
            cell.mDate.text = ""
            cell.mTime.text = ""
        }
        cell.mTour.text = match.tour
        cell.mPlace.text = match.place
        
        let titleTeamOne = getTeamTitle(league: model, match: match, team: .one)
        cell.mTitleTeam1.text = titleTeamOne
        
        let titleTeamTwo = getTeamTitle(league: model, match: match, team: .two)
        cell.mTitleTeam2.text = titleTeamTwo
        
        cell.mScore.text = match.score ?? "-"
        
        presenter.getClubImage(id: getClubIdByTeamId(match.teamOne ?? "", league: model))
        { (image) in
            cell.mImageTeam1.image = image.af_imageRoundedIntoCircle()
        }
        presenter.getClubImage(id: getClubIdByTeamId(match.teamTwo ?? "", league: model))
        { (image) in
            cell.mImageTeam2.image = image.af_imageRoundedIntoCircle()
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

extension ScheduleTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (leagueDetailModel.leagueInfo.league.matches?[indexPath.row].played)! {
            return indexPath
        }
        return nil
    }
}
