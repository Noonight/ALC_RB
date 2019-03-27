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
        var tournaments: Tournaments?
        var clubs: Clubs?
        
        init(tournaments: Tournaments, clubs: Clubs) {
            self.tournaments = tournaments
            self.clubs = clubs
        }
        
        init () { }
        
        func isEmpty() -> Bool {
            return tournaments == nil || clubs == nil
        }
    }
    
    // MARK: - Variables
    
    let cellId = "ongoing_cell"
    let emptyMsg = "Вы пока не заявлены ни на один турнир"
    
    let userDefaults = UserDefaultsHelper()
    
    let presenter = OngoingLeaguesLKPresenter()
    
    var tableModel = TableModel() {
        didSet {
            if !tableModel.isEmpty() {
                self.hideLoading()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        setEmptyMessage(message: emptyMsg)
        
        tableView.tableFooterView = UIView()
        
//        var userSet = userDefaults.getAuthorizedUser()
//        userSet?.person.participation = [
//            Participation(league: "5be94d1a06af116344942a92", id: "23rsdfgdwef", team: "5be94d1a06af116344942aad"),
//            Participation(league: "5be94d1a06af116344942a92", id: "123fsdfewf23", team: "5be94d1a06af116344942ae7"),
//            Participation(league: "5be94d1a06af116344942a92", id: "asd23f4g34fs", team: "5be94d1a06af116344942a93"),
//        ]
//        userDefaults.setAuthorizedUser(user: userSet!)
        
        
//        let user = userDefaults.getAuthorizedUser()?.person
//
//        if user?.participation.count ?? 0 > 0 {
//            hideEmptyView()
//            if tableModel.isEmpty() {
//                showLoading()
//            } else {
//                hideLoading()
//            }
//        } else {
//            showEmptyView()
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if userDefaults.getAuthorizedUser()?.person.participation.count ?? 0 > 0 {
            hideEmptyView()
            if tableModel.isEmpty() {
                showLoading()
            } else {
                hideLoading()
            }
        } else {
            showEmptyView()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaults.getAuthorizedUser()?.person.participation.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OngoingLeagueTableViewCell
        let model = userDefaults.getAuthorizedUser()?.person.participation[indexPath.row]
        
        configureCell(model: model!, cell: cell)
        
        return cell
    }
    
    func configureCell(model: Participation, cell: OngoingLeagueTableViewCell) {
        
        if !tableModel.isEmpty() {
            let league = tableModel.tournaments?.leagues.filter({ (league) -> Bool in
                return league.id == model.league
            }).first
            let team = league?.teams.filter({ (team) -> Bool in
                return team.id == model.team
            }).first
            let club = tableModel.clubs?.clubs.filter({ (club) -> Bool in
                return club.id == team?.club
            }).first
            
            
            
            if let league = league {
                
                Print.m("\(league.beginDate) ->> \(league.endDate)")
                
                cell.userTournamentTitle_label.text = "\(league.name). \(league.tourney)"
                cell.userTournamentDate_label.text = "\(league.beginDate.UTCToLocal(from: .leagueDate, to: .local)) - \(league.endDate.UTCToLocal(from: .leagueDate, to: .local))"
            }
            
            if let team = team {
                cell.userTournamentCommandTitle_label.text = team.name
            }
            
            if let club = club {
                presenter.getClubImage(imagePath: club.logo ?? "", get_success: { (image) in
                    cell.userTournamentLogo_image.image = image.af_imageRoundedIntoCircle()
                }) { (error) in
                    Print.m(error)
                }
            }
        }
        
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension OngoingLeaguesLKTableViewController: OngoingLeaguesLKView {
    
    func getClubsSuccess(clubs: Clubs) {
        tableModel.clubs = clubs
    }
    
    func getClubsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func getTournamentsSuccess(tournaments: Tournaments) {
        tableModel.tournaments = tournaments
    }
    
    func getTournamentsFailure(error: Error) {
        Print.d(error: error)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        presenter.getTournaments()
        presenter.getClubs()
    }
}
