//
//  TeamsLeagueViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamsLeagueTableViewController: UITableViewController {
    
    static func getInstance() -> TeamsLeagueTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "TeamsLeagueTableViewController") as! TeamsLeagueTableViewController
        
        return viewController
    }
    
    enum Texts {
        static let HERE_WILL_SHOW_TEAMS = "Здесь будут отображаться команды"
    }
    enum SegueIdentifiers {
        static let DETAIL = "segue_team_league_detail"
    }
    
    // MARK: OUTLETS
    
    @IBOutlet var emptyView: UIView!
    
    // MARK: VAR & LET
    
    var filteredTeamsTable: FilteredTeamsLeagueTableView = FilteredTeamsLeagueTableView()
    var allTeamsTable: AllTeamsLeagueTableView = AllTeamsLeagueTableView()
    var leagueDetailModel = LeagueDetailModel() {
        didSet {
            updateUI()
        }
    }
    let menuLauncher = MenuLauncher()
    
    var backgroundView = UIView()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitle()
        self.setupQMenu()
//        self.setupTableViews()
        self.setupTableViewHeaderCell()
//        self.setupTableDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavBtn()
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.unSetupNavBarRightItem()
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension TeamsLeagueTableViewController {
    
    func setupTableViewHeaderCell() {
        tableView.register(filteredTeamsTable.tableHeaderViewCellNib, forCellReuseIdentifier: FilteredTeamsLeagueTableView.CellIdentifiers.HEADER)
    }
    
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
    
    func setupFilteredTableViews() {
        self.tableView.delegate     = filteredTeamsTable
        self.tableView.dataSource   = filteredTeamsTable
        
        self.tableView.tableFooterView = UIView()
    }
    
    func setupAllTableViews() {
        self.tableView.delegate     = allTeamsTable
        self.tableView.dataSource   = allTeamsTable
        
        self.tableView.tableFooterView = UIView()
    }
    
    func setupFilteredTableDataSource() {
//        dump(self.leagueDetailModel.league.stages)
//        if
        self.filteredTeamsTable.initDataSource(teams: self.leagueDetailModel.league.teams!, groups: self.leagueDetailModel.league.stages!.first!.groups!)
        self.tableView.reloadData()
    }
    
    func setupAllTableDataSource() {
        self.allTeamsTable.initDataSource(teams: self.leagueDetailModel.league.teams!)
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
        if leagueTeamsIsEmpty() == true
        {
            showEmptyView()
        }
        else
        {
//            if allTeamsIsContainsGroup() == true
//            {
//                Print.m("all teams contains groups")
            if self.leagueDetailModel.league.stages?.first?.groups?.isEmpty ?? true {
                self.setupAllTableViews()
                self.setupAllTableDataSource()
            } else {
                self.setupFilteredTableViews()
                self.setupFilteredTableDataSource()
            }
//                self.setupFilteredTableViews()
//                self.setupFilteredTableDataSource()
                Print.m("setup data source of fitlered teams and reload table view data")
//            }
//            else
//            {
//                Print.m("some teams do not contains groups")
//                self.setupAllTableViews()
//                self.setupAllTableDataSource()
//                Print.m("setup data source of all teams and reload table view data")
//            }
            hideEmptyView()
            tableView.reloadData()
        }
    }
    
    func leagueTeamsIsEmpty() -> Bool {
//        Print.m(leagueDetailModel.league.teams) // group can bel nil
        return leagueDetailModel.league.teams!.isEmpty
    }
    
    func allTeamsIsContainsGroup() -> Bool {
        guard let teams = leagueDetailModel.league.teams else { return false }
        for team in teams
        {
                // DEPRECATED: group deprecated
//            Print.m(team.group)
////            guard team.group != nil else { return false }
////            Print.m(team.group)
//            if team.group?.count ?? 0 == 0 // nothing
//            {
//                return false
//            }
        }
        return true
    }
}

// MARK: LEAGUE MAIN PROTOCOL

//extension TeamsLeagueTableViewController: LeagueMainProtocol {
//    func updateData(leagueDetailModel: LeagueDetailModel) {
//        self.leagueDetailModel = leagueDetailModel
////        updateUI()
//    }
//}

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
    }
    
    func hideEmptyView() {
        tableView.separatorStyle = .singleLine
        backgroundView.removeFromSuperview()
    }
}

// MARK: NAVIGATION

extension TeamsLeagueTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == SegueIdentifiers.DETAIL,
            let destination = segue.destination as? TeamLeagueDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            var team: Team!
//            if self.allTeamsIsContainsGroup() == true
//            {
            if self.leagueDetailModel.league.stages?.first?.groups?.isEmpty ?? true {
                team = self.allTeamsTable.dataSource[indexPath.row - AllTeamsLeagueTableView.HeaderCell.COUNT]
            } else {
                team = self.filteredTeamsTable.dataSource[indexPath.section].teams[indexPath.row - FilteredTeamsLeagueTableView.HeaderCell.COUNT]
            }
//                team = self.filteredTeamsTable.dataSource[indexPath.section].teams[indexPath.row - FilteredTeamsLeagueTableView.HeaderCell.COUNT]
//            }
//            else
//            {
//                team = self.allTeamsTable.dataSource[indexPath.row - AllTeamsLeagueTableView.HeaderCell.COUNT]
//            }
            destination.teamModel = team
            let matches = leagueDetailModel.league.matches?.filter { (match) -> Bool in
                return match.teamOne?.getId() ?? match.teamOne?.getValue()!.id == team.id || match.teamTwo?.getId() ?? match.teamTwo?.getValue()!.id == team.id
            }
            destination.teamMatches = matches!
            destination.league = leagueDetailModel.league
        }
    }
}
