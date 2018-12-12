//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: UITableViewController, MvpView {

    //MARK: - Properties
    
    let tournamentFinished = "Finished"
    
    var tournaments = Tournaments()
    
    let presenter = TournamentsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        initPresenter()
    }
    
    private func initView() {
        
        tableView.tableFooterView = UIView()
        
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getTournaments()
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    func onGetTournamentSuccess(tournament: Tournaments) {
        self.tournaments = tournament
        updateUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.leagues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_tournament", for: indexPath) as! TournamentTableViewCell
        //cell.img?.image =
        cell.title?.text = tournaments.leagues[indexPath.row].tourney
        cell.date?.text = "\(tournaments.leagues[indexPath.row].beginDate) - \(tournaments.leagues[indexPath.row].endDate)"
        //cell.date?.text = "10.03.2018 - 10.04.2018"
        cell.commandNum?.text = "Количество команд: \(tournaments.leagues[indexPath.row].maxTeams)"
        if (tournaments.leagues[indexPath.row].status == tournamentFinished) {
            cell.img?.image = UIImage(named: "ic_fin")
        } else {
            
        }
        //cell.img?.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
