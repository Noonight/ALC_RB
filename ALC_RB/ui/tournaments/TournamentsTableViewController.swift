//
//  TournamentsTableViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class TournamentsTableViewController: BaseStateTableViewController {
    private enum Variables {
        static let errorAlertTitle = "Ошибка!"
        static let errorAlertOk = "Ок"
        static let errorAlertRefresh = "Перезагрузка"
    }
    
    //MARK: - Properties
    
    let tournamentFinished = "Finished"
    
    var tournaments = Tournaments()
    
    let presenter = TournamentsPresenter()
    
    let segueId = "TournamentsDetailSegue"
    
    let cellId = "cell_tournament"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        initPresenter()
        self.fetch = self.presenter.getTournaments
        refreshData()
        setEmptyMessage(message: "Здесь будут отображаться турниры")
    }
    
    private func initView() {
        tableView.tableFooterView = UIView()
    }
}

extension TournamentsTableViewController: TournamentsView {
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
    
    func onGetTournamentSuccess(tournament: Tournaments) {
        self.tournaments = tournament
        endRefreshing()
    }
    
    func onGetTournamentFailure(error: Error) {
        endRefreshing()
        showFailFetchRepeatAlert(message: error.localizedDescription) {
            self.refreshData()
        }
        Print.m(error)
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
        let model = tournaments.leagues[indexPath.row]
        
        configureCell(cell, model)
        
        return cell
    }
    
    func configureCell(_ cell: TournamentTableViewCell, _ model: League) {
        cell.title?.text = model.tourney + ". " + model.name
        cell.date?.text = "\(model.beginDate.UTCToLocal(from: .leagueDate, to: .local)) - \(model.endDate.UTCToLocal(from: .leagueDate, to: .local))"
        //cell.date?.text = "10.03.2018 - 10.04.2018"
        //cell.commandNum?.text = "Количество команд: \(tournaments.leagues[indexPath.row].maxTeams)"
        cell.commandNum?.text = String(model.maxTeams)
        cell.img?.image = #imageLiteral(resourceName: "ic_con")
        if (model.status == tournamentFinished) {
            cell.img?.image = UIImage(named: "ic_fin")
            //cell.status.text = "Завершен"
            cell.status.isHidden = false
        } else {
            //cell.status.text = ""
            cell.status.isHidden = true
        }
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
            //destination.league = tournaments.leagues[cellIndex]
            destination.leagueDetailModel = LeagueDetailModel(tournaments.leagues[cellIndex])
        }
    }
}

extension TournamentsTableViewController {
    override func hasContent() -> Bool {
        if tournaments.count != 0 {
            return true
        } else {
            return false
        }
    }
}
