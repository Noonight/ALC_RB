//
//  MatchesTeamLeagueDetailTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 18.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchesTeamLeagueDetailTableViewController: UITableViewController {

    let cellId = ""
    
    var leagueDetailModel: LeagueDetailModel = LeagueDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MatchesTeamLeagueDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        return cell
    }
}


extension MatchesTeamLeagueDetailTableViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
    }
}
