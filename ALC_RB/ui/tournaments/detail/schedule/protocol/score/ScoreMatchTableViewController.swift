//
//  ScoreMathTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 14.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ScoreMatchTableViewController: UITableViewController {

    // MARK: - Table struct
    
    struct TableStruct {
//        var
    }
    
    // MARK: - Variables
    
    let cellId = "score_match_cell"
    let presenter = ScoreMatchPresenter()
    
    let leagueDetailModel = LeagueDetailModel()
    let match = Match()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return match.events.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ScoreMatchTableViewCell

        

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScoreMatchTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
