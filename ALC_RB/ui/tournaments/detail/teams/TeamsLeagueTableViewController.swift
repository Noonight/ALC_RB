//
//  TeamsLeagueViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamsLeagueTableViewController: UITableViewController {

    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    let cellId = "cell_league_team"
    let segueId = "segue_team_league_detail"
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = " "
    }
}

extension TeamsLeagueTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == segueId,
            let destination = segue.destination as? TeamLeagueDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            //destination.league = tournaments.leagues[cellIndex]
            let team = leagueDetailModel.leagueInfo.league.teams[cellIndex]
            destination.teamModel = team
            let matches = leagueDetailModel.leagueInfo.league.matches.filter { (match) -> Bool in
                return match.teamOne == team.id || match.teamTwo == team.id
            }
            destination.teamMatches = matches
            destination.league = leagueDetailModel.leagueInfo.league
        }
    }
}

extension TeamsLeagueTableViewController {
    func updateUI() {
        checkEmptyView()
    }
    
    func checkEmptyView() {
        if leagueTeamsIsEmpty() {
            showEmptyView()
        } else {
            hideEmptyView()
            
            tableView.reloadData()
        }
    }
    
    func leagueTeamsIsEmpty() -> Bool {
        return leagueDetailModel.league.teams.isEmpty
    }
}

extension TeamsLeagueTableViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
        updateUI()
    }
}

extension TeamsLeagueTableViewController: EmptyProtocol {
    func showEmptyView() {
        //if tableView.is
        tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        tableView.backgroundView?.addSubview(emptyView)
        emptyView.setCenterFromParent()
        tableView.separatorStyle = .none
        tableHeaderView.isHidden = true
        //tableHeaderView.backgroundColor = UIColor.lightGray
        //emptyView.center.y = emptyView.center.y - tableHeaderView.frame.height
    }
    
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
        tableHeaderView.isHidden = false
    }
}

extension TeamsLeagueTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 37))
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 37)
        view.addSubview(tableHeaderView)
        
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueDetailModel.league.teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamLeagueTableViewCell
        let model = leagueDetailModel.league.teams[indexPath.row]
        
        cell.selectionStyle = .none
        
        configureCell(cell, model)
        
        return cell
    }
    
    func configureCell(_ cell: TeamLeagueTableViewCell, _ model: Team) {
        //cell.position_label.text = model.playoffPlace ?? "-"
        //cell.team_btn.titleLabel?.text = model.name
        cell.team_btn.setTitle(model.name, for: .normal)
        cell.games_label.text = String(model.wins + model.losses)
        cell.rm_label.text = String(model.goals - model.goalsReceived)
        cell.score_label.text = String(model.groupScore)
    }
}

extension TeamsLeagueTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        return nil
//    }
}
