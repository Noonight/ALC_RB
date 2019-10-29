//
//  AllTeamsLeagueTableView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class AllTeamsLeagueTableView : NSObject {
    enum CellIdentifiers {
        static let TEAM = "cell_league_team"
        static let HEADER = "cell_header_league_team"
    }
    enum HeaderCell {
        static let COUNT = 1
    }
    
    let tableHeaderViewCellNib = UINib(nibName: "TournamentTeamHeaderCellTableViewCell", bundle: nil)
    var _dataSource: [LITeam] = []
    var dataSource: [LITeam] {
        get {
            return self._dataSource
        }
        set {
            var newVal = newValue
            newVal = newVal.sorted { lTeam, rTeam -> Bool in
                return lTeam.groupScore ?? 0 > rTeam.groupScore ?? 0 // sort from high to low
            }// MARK: TODO with correct status
            self._dataSource = newVal
        }
    }
    
    init(dataSource: [LITeam]) {
        super.init()
        self.initDataSource(teams: dataSource)
    }
    
    override init() { }
}

// MARK: EXTENSIONS

// MARK: INIT

extension AllTeamsLeagueTableView {
    func initDataSource(teams: [LITeam]) {
        self.dataSource = teams
    }
}

// MARK: DELEGATE

extension AllTeamsLeagueTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: DATA SOURCE

extension AllTeamsLeagueTableView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + HeaderCell.COUNT
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.HEADER, for: indexPath) as! TournamentTeamHeaderCellTableViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TEAM, for: indexPath) as! TeamLeagueTableViewCell
            let model = dataSource[indexPath.row - HeaderCell.COUNT]
            
            (cell as! TeamLeagueTableViewCell).configure(team: model)
            
            (cell as! TeamLeagueTableViewCell).position_label.text = String(indexPath.row - HeaderCell.COUNT)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
