//
//  TeamsTableView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class FilteredTeamsLeagueTableView : NSObject {
    enum CellIdentifiers {
        static let TEAM = "cell_league_team"
        static let HEADER = "cell_header_league_team"
    }
    enum HeaderCell {
        static let COUNT = 1
    }
    
    let tableHeaderViewCellNib = UINib(nibName: "TournamentTeamHeaderCellTableViewCell", bundle: nil)
    var _dataSource: [FilterTeamsByGroupHelper.GroupedLITeam] = []
    var dataSource: [FilterTeamsByGroupHelper.GroupedLITeam] {
        get {
            return self._dataSource
        }
        set {
            let newVal = newValue
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

extension FilteredTeamsLeagueTableView {
    func initDataSource(teams: [LITeam]) {
        self.dataSource = FilterTeamsByGroupHelper.filter(teams: teams)
    }
}

// MARK: DELEGATE

extension FilteredTeamsLeagueTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: DATA SOURCE

extension FilteredTeamsLeagueTableView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource[section].teams.count + HeaderCell.COUNT
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
            let model = dataSource[indexPath.section].teams[indexPath.row - HeaderCell.COUNT]
            
            (cell as! TeamLeagueTableViewCell).configure(team: model)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
