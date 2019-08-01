//
//  TeamsTableView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamsLeagueTableView : NSObject {
    enum CellIdentifiers {
        static let TEAM = "cell_league_team"
    }
    
    var tableHeaderView = TournamentTeamHeaderView()
    var isHidden = false {
        didSet {
            self.tableHeaderView.isHidden = self.isHidden
        }
    }
    var _dataSource: [LITeam] = []
    var dataSource: [LITeam] {
        get {
            return self._dataSource
        }
        set {
            var newVal = newValue
            newVal = newVal.sorted { lTeam, rTeam -> Bool in
                return lTeam.groupScore ?? 0 > rTeam.groupScore ?? 0
            }
            self._dataSource = newVal
        }
    }
    
    init(dataSource: [LITeam]) {
        super.init()
        self.dataSource = dataSource
    }
    
    override init() { }
}

extension TeamsLeagueTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TeamsLeagueTableView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: TournamentTeamHeaderView.HEIGHT))
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: TournamentTeamHeaderView.HEIGHT)
        view.addSubview(tableHeaderView)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.TEAM, for: indexPath) as! TeamLeagueTableViewCell
        let model = dataSource[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.configure(team: model)
        
        return cell
    }
}
