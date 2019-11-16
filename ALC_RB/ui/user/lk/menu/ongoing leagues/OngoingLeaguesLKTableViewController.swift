//
//  OngoingLeaguesLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class OngoingLeaguesLKTableViewController: BaseStateTableViewController {

    struct TableModel {
        var tournaments: [Tourney]!
        var clubs: [Club]!
        
        init(tournaments: [Tourney], clubs: [Club]) {
            self.tournaments = tournaments
            self.clubs = clubs
        }
        
        init () {
            self.tournaments = [Tourney]()
            self.clubs = [Club]()
        }
        
        func isEmpty() -> Bool {
            return tournaments.count != 0 && clubs.count != 0
        }
    }
    
    // MARK: - Variables
    
    let cellId = "ongoing_cell"
    let emptyMsg = "Вы пока не заявлены ни на один турнир"
    
    let userDefaults = UserDefaultsHelper()
    
    let presenter = OngoingLeaguesLKPresenter()
    
    var tableModel = TableModel()// {
//        didSet {
//            if !tableModel.isEmpty() {
//                self.hideLoading()
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preparePresenter()
        self.prepareTableView()
        self.prepareEmptyState()
        self.prepareRefreshController()
        
        self.refreshData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        if userDefaults.getAuthorizedUser()?.person.participation.count ?? 0 > 0 {
//            hideEmptyView()
//            if tableModel.isEmpty() {
//                showLoading()
//            } else {
//                hideLoading()
//            }
//        } else {
//            showEmptyView()
//        }
//    }
}

// MARK: Extensions

// MARK: Prepare

extension OngoingLeaguesLKTableViewController {
    func prepareTableView() {
        self.tableView.tableFooterView = UIView()
    }
    func prepareEmptyState() {
        self.setEmptyMessage(message: emptyMsg)
    }
    func preparePresenter() {
        self.initPresenter()
    }
    func prepareRefreshController() {
        self.fetch = self.presenter.fetch
    }
}

// MARK: Refresh controller

extension OngoingLeaguesLKTableViewController {
    override func hasContent() -> Bool {
//        Print.m(userDefaults.getAuthorizedUser()?.person.participation)
//        return /*!self.tableModel.isEmpty() && */ userDefaults.getAuthorizedUser()?.person.participation.count != 0
        return true
    }
}

// MARK: Presenter

extension OngoingLeaguesLKTableViewController: OngoingLeaguesLKView {
    func onFetchSuccess() {
        self.endRefreshing()
    }
    
    
    func getClubsSuccess(clubs: [Club]) {
        tableModel.clubs = clubs
    }
    
    func getClubsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getTournamentsSuccess(tournaments: [Tourney]) {
        tableModel.tournaments = tournaments
    }
    
    func getTournamentsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: - Table view data source

extension OngoingLeaguesLKTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return userDefaults.getAuthorizedUser()?.person.participation.count ?? 0
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OngoingLeagueTableViewCell
//        let model = userDefaults.getAuthorizedUser()?.person.participation[indexPath.row]
        
//        configureCell(model: model!, cell: cell)
        
        return cell
    }
    
//    func configureCell(model: Participation, cell: OngoingLeagueTableViewCell) {
//
//        if !tableModel.isEmpty() {
//            let league = tableModel.tournaments?.leagues.filter({ (league) -> Bool in
//                return league.id == model.league
//            }).first
//            let team = league?.teams!.filter({ (team) -> Bool in
//                return team.id == model.team
//            }).first
//            let club = tableModel.clubs?.clubs.filter({ (club) -> Bool in
//                return club.id == team?.club
//            }).first
//
//            if let league = league {
//
//                cell.userTournamentTitle_label.text = "\(league.name). \(league.tourney)"
//                cell.userTournamentDate_label.text = "\(league.beginDate!.toFormat(DateFormats.local.ck)) - \(league.endDate!.toFormat(DateFormats.local.ck))"
//            }
//
//            if let team = team {
//                cell.userTournamentCommandTitle_label.text = team.name
//            }
//
//            if let club = club {
//                presenter.getClubImage(imagePath: club.logo ?? "", get_success: { (image) in
//                    cell.userTournamentLogo_image.image = image.af_imageRoundedIntoCircle()
//                }) { (error) in
//                    Print.m(error)
//                }
//            }
//        }
//
//    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
