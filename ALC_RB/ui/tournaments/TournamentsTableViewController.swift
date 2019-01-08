//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: UITableViewController {

    //MARK: - Properties
    
    let tournamentFinished = "Finished"
    
    var tournaments = Tournaments()
    
    let presenter = TournamentsPresenter()
    
    let segueId = "TournamentsDetailSegue"
    
    let cellId = "cell_tournament"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
//        tournaments.leagues = [
//            League(status: "Завершено", matches: [
//                   "match one",
//                   "match two"
//                ], id: "some id", tourney: "Турнир", name: "Имя", beginDate: "10.10.2010", endDate: "10.12.2012", maxTeams: 32, teams: [], transferBegin: "some date transfer", transferEnd: "some date transfer", playersMin: 16, playersMax: 64, playersCapacity: 92, yellowCardsToDisqual: 3, ageAllowedMin: 6, ageAllowedMax: 3)
//        ]
        
        initPresenter()
    }
    
    private func initView() {
        
        tableView.tableFooterView = UIView()
        
    }

    func updateUI() {
        tableView.reloadData()
    }
}

extension TournamentsTableViewController: TournamentsView {
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getTournaments()
    }
    
    func onGetTournamentSuccess(tournament: Tournaments) {
        self.tournaments = tournament
        debugPrint(tournaments.leagues)
        updateUI()
    }
}

extension TournamentsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournaments.leagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TournamentTableViewCell
        //cell.img?.image =
        cell.title?.text = tournaments.leagues[indexPath.row].tourney + ". " + tournaments.leagues[indexPath.row].name
        cell.date?.text = "\(tournaments.leagues[indexPath.row].beginDate) - \(tournaments.leagues[indexPath.row].endDate)"
        //cell.date?.text = "10.03.2018 - 10.04.2018"
        //cell.commandNum?.text = "Количество команд: \(tournaments.leagues[indexPath.row].maxTeams)"
        cell.commandNum?.text = String(tournaments.leagues[indexPath.row].maxTeams)
        if (tournaments.leagues[indexPath.row].status == tournamentFinished) {
            cell.img?.image = UIImage(named: "ic_fin")
        } else {
            
        }
        //cell.img?.image
        return cell
    }
}

extension TournamentsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TournamentsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? LeagueDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.league = tournaments.leagues[cellIndex]
            //destination.content = NewsDetailViewController.Content(
        }
    }
}
