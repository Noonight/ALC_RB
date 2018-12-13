//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController, MvpView {

    var league = League()
    var leagueInfo = LILeagueInfo()
    
    let cellId = "cell_schedule"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
    }

    func initPresenter() {
        
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueInfo.league.matches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ScheduleTableViewCell

        cell?.mDate.text = leagueInfo.league.matches[indexPath.row].date
        cell?.mTime.text = leagueInfo.league.matches[indexPath.row].date
        cell?.mTour.text = leagueInfo.league.matches[indexPath.row].tour
        
        let title1 = leagueInfo.league.teams.filter { i -> Bool in
            i.id == leagueInfo.league.matches[indexPath.row].teamOne
        }.first?.club
        print(title1 ?? "some error")
        //cell?.mTitleTeam1.text = leagueInfo.league.teams[]

        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
