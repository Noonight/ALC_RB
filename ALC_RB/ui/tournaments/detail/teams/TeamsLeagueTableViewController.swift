//
//  TeamsLeagueViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamsLeagueTableViewController: UITableViewController {
    enum Texts {
        static let HERE_WILL_SHOW_TEAMS = "Здесь будут отображаться команды"
    }
    enum SegueIdentifiers {
        static let DETAIL = "segue_team_league_detail"
    }
    
    // MARK: OUTLETS
    
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    // MARK: VAR & LET
    
    var teamsTable: TeamsLeagueTableView = TeamsLeagueTableView()
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    var screenWidth: CGFloat = UIScreen.main.bounds.width {
        didSet {
            let screenWidth = UIScreen.main.bounds.width
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 37)
        }
    }
    let menuLauncher = MenuLauncher()
    
    var backgroundView = UIView()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitle()
        self.setupQMenu()
        self.setupTableViews()
        self.setupTableDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBtn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.unSetupNavBarRightItem()
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension TeamsLeagueTableViewController {
    
    func setupQMenu() {
        menuLauncher.menuSettings = [
            Menu(name: "№ - место в турнире"),
            Menu(name: "И - количество проведенных матчей"),
            Menu(name: "В - победы"),
            Menu(name: "РМ - разница забитых и пропущенных мячей"),
            Menu(name: "О - количество очков")
        ]
    }
    
    func setupTitle() {
        self.title = " "
    }
    
    func setupTableViews() {
        self.tableView.delegate     = teamsTable
        self.tableView.dataSource   = teamsTable
        
        self.tableView.tableFooterView = UIView()
    }
    
    func setupTableDataSource() {
        self.teamsTable.dataSource = self.leagueDetailModel.leagueInfo.league.teams!
        self.tableView.reloadData()
    }
    
    func setupNavBtn() {
        let btn = barButtonItem(type: .info, action: #selector(onNavBarInfoPressed))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = btn
    }
}

// MARK: UN SETUP

extension TeamsLeagueTableViewController {
    
    func unSetupNavBarRightItem() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
}

// MARK: ACTIONS

extension TeamsLeagueTableViewController {
    
    @objc func onNavBarInfoPressed() {
        showMenu()
    }
    
}

// MARK: HELPERS

extension TeamsLeagueTableViewController {
    
    func showMenu() {
        menuLauncher.showMenu()
    }
    
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
        return leagueDetailModel.league.teams!.isEmpty
    }
}

// MARK: LEAGUE MAIN PROTOCOL

extension TeamsLeagueTableViewController: LeagueMainProtocol {
    func updateData(leagueDetailModel: LeagueDetailModel) {
        self.leagueDetailModel = leagueDetailModel
        updateUI()
    }
}

// MARK: EMPTY VIEW PROTOCOL

extension TeamsLeagueTableViewController: EmptyProtocol {
    func showEmptyView() {
        
        let newEmptyView = EmptyViewNew()
        
        backgroundView.frame = tableView.frame
        
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(newEmptyView)
        
        tableView.addSubview(backgroundView)
        
        newEmptyView.setText(text: Texts.HERE_WILL_SHOW_TEAMS)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        
        newEmptyView.setCenterFromParent()
        newEmptyView.containerView.setCenterFromParent()
        
        backgroundView.setCenterFromParent()
        
        tableView.bringSubviewToFront(backgroundView)
        
        tableView.separatorStyle = .none
        
        teamsTable.isHidden = true
    }
    
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        backgroundView.removeFromSuperview()
        teamsTable.isHidden = false
    }
}

// MARK: NAVIGATION

extension TeamsLeagueTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SegueIdentifiers.DETAIL,
            let destination = segue.destination as? TeamLeagueDetailViewController,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            let team = leagueDetailModel.leagueInfo.league.teams![cellIndex]
            destination.teamModel = team
            let matches = leagueDetailModel.leagueInfo.league.matches?.filter { (match) -> Bool in
                return match.teamOne == team.id || match.teamTwo == team.id
            }
            destination.teamMatches = matches!
            destination.league = leagueDetailModel.leagueInfo.league
        }
    }
}
