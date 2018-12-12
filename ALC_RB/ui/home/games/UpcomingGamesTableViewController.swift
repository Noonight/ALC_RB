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
    
    @IBOutlet var empty_view: UIView!
    
    var tableData = UpcomingMatches()
    
    private let presenter = UpcomingGamesPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        tableView.register(UpcomingGameTableViewCell.self, forCellReuseIdentifier: UpcomingGameTableViewCell.idCell)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getUpcomingGames()
    }
    
    func updateUI() {
        
        if (tableData.count == 0) {
            showEmptyView()
        }
        hideEmptyView()
        
        self.tableView.reloadData()
    }
    
    func showEmptyView() {
        tableView.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        tableView.backgroundView?.addSubview(empty_view)
        tableView.separatorStyle = .none
        empty_view.setCenterFromParent()
    }
    
    func hideEmptyView() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingGameTableViewCell.idCell, for: indexPath) as? UpcomingGameTableViewCell
        
        //cell!.configureCell(data: (tableData?.matches[indexPath.row])!)
        //cell?.data = tableData.matches[indexPath.row]
        
        cell?.setData(data: tableData.matches[indexPath.row])
        cell?.data.date = "12.12.2018"
        
        return cell!
    }
}
