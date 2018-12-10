//
//  GamesTableViewController.swift
//  ALC_RB
//
//  Created by user on 28.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UpcomingGamesTableViewController: UITableViewController, MvpView {
    
    let cellId = "cell_upcoming_game"
    
    var tableData = UpcomingMatches()
    
    private let presenter = UpcomingGamesPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        //print(#function)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getUpcomingGames()
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    func onGetUpcomingMatchesSuccesful(data: UpcomingMatches) {
        tableData = data
        //try! print(tableData.jsonString())
        updateUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.matches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UpcomingGameTableViewCell
        
        //cell!.configureCell(data: (tableData?.matches[indexPath.row])!)
        //cell?.data = tableData.matches[indexPath.row]
        
        cell?.setData(data: tableData.matches[indexPath.row])
        
        return cell!
    }
}
