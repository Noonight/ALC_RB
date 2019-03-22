//
//  OngoingLeaguesLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 15.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class OngoingLeaguesLKTableViewController: LoadingEmptyTVC {

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
        setEmptyText(text: emptyMsg)
        
        let user = userDefaults.getAuthorizedUser()?.person
        if user?.participation.count ?? 0 > 0 {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if userDefaults.getAuthorizedUser()?.person.pendingTeamInvites.count ?? 0 > 0 {
//            hideEmptyView()
//            if tableModel.isEmpty() {
//                showLoading()
//            } else {
//                hideLoading()
//            }
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.hideEmptyView()
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
    }
}
