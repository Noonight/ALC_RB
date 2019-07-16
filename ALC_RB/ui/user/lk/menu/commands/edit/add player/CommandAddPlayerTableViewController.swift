//
//  CommandAddPlayerTableViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 23/04/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class CommandAddPlayerTableViewController: BaseStateTableViewController {
    private enum CellIdentifiers {
        static let list = "cell_command_add_player"
        static let loading = "cell_command_add_player_loading"
    }
    private enum Texts {
        static let playerInTeam = "Игрок уже получил приглашение в эту команду"
    }
    
    struct TableModel {
        var players = Players()
        
        init() {}
        
        init(players: Players) {
            self.players = players
        }
    }
    
    // MARK: Var & Let
    let userDefaultsHelper = UserDefaultsHelper()
    var team = Team()
    var leagueId: String!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tableModel = TableModel()
    var filteredPlayers = Players()
    
    let presenter = CommandAddPlayerPresenter()
    
    var currentAddId: Int?
    
    // MARK: - model controllers
    var teamController: TeamCommandsController!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preparePresenter()
        self.prepareTableView()
        self.prepareSearchController()
        self.prepareRefreshControl()
        
        self.refreshData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if tableModel.players.people.count < 2 {
//            setState(state: .loading)
//            searchController.searchBar.text = ""
//            searchController.isActive = false
//            presenter.fetchPersons(offset: currentCount())
//        }
//
//    }

    // MARK: Prepare
    func prepareSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск игроков"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
            // Fallback on earlier versions
        }
        definesPresentationContext = true
    }
    func prepareTableView() {
        tableView.tableFooterView = UIView()
    }
    func preparePresenter() {
        initPresenter()
    }
    func prepareRefreshControl() {
        self.fetch = self.presenter.fetch
    }
    
    // MARK: Actions
    @objc func onAddPlayerBtnPressed(sender: UIButton) {
        var personId: String!
        if isFiltering() {
            personId = filteredPlayers.people[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(filteredPlayers.people[sender.tag])")
        } else {
            personId = tableModel.players.people[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(tableModel.players.people[sender.tag])")
        }
        let addPlayer = AddPlayerToTeam(
            _id: leagueId,
            teamId: team.id,
            playerId: personId)
        dump(userDefaultsHelper.getAuthorizedUser()?.token)
        dump(addPlayer)
        presenter.addPlayerToTeamForLeague(token: userDefaultsHelper.getAuthorizedUser()!.token, addPlayerToTeam: addPlayer)
        currentAddId = sender.tag
    }
    
    @objc func onLoadMoreBtnPressed(sender: UIButton) {
//        onBtnLoadMorePressed(button: sender)
        Print.m("good job -> currentCount is \(currentCount()) // totalCount is \(totalCount())")
        
        if currentCount() < totalCount() {
            Print.m("start loading new persons from offset - \(currentCount())")
            presenter.fetchPersons(offset: currentCount())
        }
        
        if currentCount() == totalCount() {
            sender.setTitle("Конец", for: .normal)
        }
    }
}

// MARK: Extensions

// MARK: Refresh controller
extension CommandAddPlayerTableViewController {
    override func hasContent() -> Bool {
        if tableModel.players.people.count != 0 {
            return true
        } else {
            return false
        }
    }
}
// MARK: Search controller
extension CommandAddPlayerTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForQuery(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForQuery(_ query: String, scope: String = "All") {
//        if (CACurrentMediaTime() - currentTimeOfSearch) > 5 {
            if query.count > 1 {
                Print.m("Query is \(query)")
                presenter.findPersons(query: query)
            }
//        updateUI()
        self.tableView.reloadData()
//        }
    }
    
    func isFiltering() -> Bool {
        let isFilter = searchController.isActive && !searchBarIsEmpty()
        return isFilter
    }
}

// MARK: Helper delete
private extension CommandAddPlayerTableViewController {
    func isLoadingCell (for indexPath: IndexPath) -> Bool {
        return indexPath.row == tableModel.players.people.count
    }
    
    func totalCount() -> Int {
        return tableModel.players.count
    }
    
    func currentCount() -> Int {
        return tableModel.players.people.count
    }
    
    func deleteLastChosenRow() {
        tableView.beginUpdates()
        tableModel.players.people.remove(at: currentAddId!)
        tableView.deleteRows(at: [IndexPath(row: currentAddId!, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
}
// MARK: Presenter
extension CommandAddPlayerTableViewController : CommandAddPlayerView {
    func onFetchSuccessful(player: Players) {
        self.tableModel.players = player
        self.endRefreshing()
    }
    
    func onFetchFailure(error: Error) {
        Print.m(error)
        self.endRefreshing()
    }
    
    func onRequestAddPlayerToTeamSuccess(liLeagueInfo: LILeagueInfo) {
        //        teamController.addPlayerById(id: team.id, player: tableModel.players.people[currentId])
        if let team = liLeagueInfo.league.teams?.filter({ liTeam -> Bool in
            return liTeam.id == team.id
        }).first {
            var convertedPlayers: [Player] = []
            for i in 0..<team.players!.count {
                convertedPlayers.append(team.players![i].convertToPlayer())
            }
            teamController.setPlayersByTeamId(id: team.id!, players: convertedPlayers)
//            teamController.addPlayerById(id: team.id, player: <#T##Player#>)
        }
        
        deleteLastChosenRow()
    }
    
    func onFetchQueryPersonsSuccess(players: Players) {
        // asd
        Print.m(players)
        filteredPlayers = players
//        updateUI()
    }
    
    func onFetchQueryPersonsFailure(error: Error) {
        // dsa
        setState(state: BaseState.error(message: error.localizedDescription))
    }
    
    func onRequestAddPlayerToTeamMessage(singleLineMessage: SingleLineMessage) {
        // somwthing
        Print.m(singleLineMessage.message)
        showAlert(title: singleLineMessage.message, message: "")
    }
    
    func onRequestAddPlayerToTeamError(error: Error) {
//        showToast(message: "Неизвестная ошибка.")
        showAlert(message: error.localizedDescription)
        Print.m(error)
        // something
    }
    
    func onFetchPersonsSuccess(players: Players) {
        self.setState(state: .normal)
        if tableModel.players.count == 0 {
            tableModel.players = players
        } else {
            tableModel.players.people.append(contentsOf: players.people)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func onFetchPersonsFailure(error: Error) {
        self.setState(state: .error(message: error.localizedDescription))
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
    }
}

// MARK: Table view
extension CommandAddPlayerTableViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            Print.m("is filtering - \(self.isFiltering()) && \(filteredPlayers.count)")
            return filteredPlayers.count
        }
        return tableModel.players.people.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! CommandAddPlayerTableViewCell
        
        let player: Person
        if isFiltering() {
            player = filteredPlayers.people[indexPath.row]
            let teamPlayers = teamController.getTeamById(id: self.team.id)?.players
            cell.usedPlayers = teamPlayers!
            cell.configure(with: player)
            
            cell.cell_add_player_btn.tag = indexPath.row
            cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
        } else {
            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
                cell.cell_loadMore_btn.addTarget(self, action: #selector(onLoadMoreBtnPressed), for: .touchUpInside)
                
            } else {
                player = tableModel.players.people[indexPath.row]
                
                cell.configure(with: player)
                cell.cell_add_player_btn.tag = indexPath.row
                cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
                cell.tag = indexPath.row
            }
        }
        
        return cell
    }
    // MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Print.m("cell did select")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
