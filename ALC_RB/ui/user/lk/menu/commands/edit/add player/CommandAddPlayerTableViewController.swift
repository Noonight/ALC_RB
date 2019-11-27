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
        static let PLAYER_IN_ANOTHER_TEAM = "В составе "
        static let PLAYER_INVITED_TO = "Приглашен в команду "
        static let IN_YOUR_TEAM = "В составе вашей команды"
        static let INVITED_INTO_YOUR_TEAM = "Приглашен в вашу команду"
    }
    
    struct TableModel {
        var players = [Person]()
        
        init() {}
        
        init(players: [Person]) {
            self.players = players
        }
    }
    
    // MARK: Var & Let
    let userDefaultsHelper = UserDefaultsHelper()
    var team = Team()
    var leagueId: String!
//    var leagueController: LeagueController!
    let searchController = UISearchController(searchResultsController: nil)
    
    var tableModel = TableModel()
    var filteredPlayers = [Person]()
    
    let presenter = CommandAddPlayerPresenter()
    
    var currentAddId: Int?
    
    var paginationHelper: PaginationHelper! // need init after first fetch data and on every pull to refresh action
    
    // MARK: - model controllers
    var teamController: TeamCommandsController!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preparePresenter()
        self.prepareTableView()
        self.prepareSearchController()
        self.prepareRefreshController()
        self.prepareInfiniteScrollController()
        
        self.refreshData()
    }

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
    func prepareRefreshController() {
        self.fetch = self.presenter.fetch
    }
    func prepareInfiniteScrollController() {
        self.tableView.infiniteScrollIndicatorMargin = 40
        self.tableView.infiniteScrollTriggerOffset = 500
        self.tableView.addInfiniteScroll { tableView in
            Print.m("infinite scroll trigered")
            self.presenter.fetchInfScroll(offset: self.paginationHelper.getCurrentCount())
        }
    }
}

// MARK: Extensions

// MARK: Refresh controller
extension CommandAddPlayerTableViewController {
    override func hasContent() -> Bool {
        if tableModel.players.count != 0 {
            return true
        } else {
            return false
        }
    }
}

// MARK: Search controller
extension CommandAddPlayerTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.tableView.removeInfiniteScroll()
            self.refreshControl = nil
            if searchController.searchBar.text?.count ?? 0 > 2 {
                filterContentForQuery(searchController.searchBar.text!)
            } else {
                filteredPlayers = []
                tableView.reloadData()
            }
            Print.m("search controller is active")
        } else {
            Print.m("search controller is not active")
           self.tableView.reloadData()
            // configure deleted interacive features
            self.setupPullToRefresh()
            //            self.prepareRefreshController()
            self.prepareInfiniteScrollController()
            
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForQuery(_ query: String, scope: String = "All") {
//        if (CACurrentMediaTime() - currentTimeOfSearch) > 5 {
//            if query.count > 1 {
//                Print.m("Query is \(query)")
                presenter.findPersons(query: query)
//            }
//        updateUI()
//        self.tableView.reloadData()
//        }
    }
    
    func isFiltering() -> Bool {
        let isFilter = searchController.isActive && !searchBarIsEmpty()
        return isFilter
    }
}

// MARK: Actions
extension CommandAddPlayerTableViewController {
    @objc func onAddPlayerBtnPressed(sender: UIButton) {
        Print.m("add player btn pressed. Tag of button is \(sender.tag)")
        var personId: String!
        if isFiltering() {
            Print.m("person id on \(sender.tag) is \(filteredPlayers[sender.tag].id)")
            personId = filteredPlayers[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(filteredPlayers[sender.tag])")
        } else {
            personId = tableModel.players[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(tableModel.players[sender.tag])")
        }
        let addPlayer = AddPlayerToTeam(
            _id: leagueId,
            teamId: team.id,
            playerId: personId)
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

// MARK: Helper delete
private extension CommandAddPlayerTableViewController {
    func isLoadingCell (for indexPath: IndexPath) -> Bool {
        return indexPath.row == tableModel.players.count
    }
    
    func totalCount() -> Int {
        return tableModel.players.count
    }
    
    func currentCount() -> Int {
        return tableModel.players.count
    }
}

// MARK: Presenter
extension CommandAddPlayerTableViewController : CommandAddPlayerView {
    func onFetchScrollSuccessful(players: [Person]) {
        Print.m("new players count is \(self.tableModel.players.count + players.count)")
        // create new index paths
        let playersCount = self.tableModel.players.count // current count of players
        let responsePlayersCount = players.count + playersCount // current count of response players
        let (start, end) = (playersCount, responsePlayersCount)
        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
        
        // update data source
        self.tableModel.players.append(contentsOf: players)
//        self.numPages = response.nbPages
//        self.currentPage += 1
        self.paginationHelper.setCurrentCount(newCount: self.tableModel.players.count)
        self.paginationHelper.setTotalCount(newCount: players.count)
        
        // update table view
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .automatic)
        self.tableView.endUpdates()
        
        self.tableView.finishInfiniteScroll()
        
        if self.paginationHelper.getCurrentCount() == self.paginationHelper.getTotalCount() {
            self.tableView.removeInfiniteScroll()
        }
    }
    
    func onFetchScrollFailure(error: Error) {
        self.tableView.finishInfiniteScroll()
        showAlert(message: error.localizedDescription)
    }
    
    func onFetchSuccessful(player: [Person]) {
        self.tableModel.players = player
        // if pull to refresh used pages also update
        self.prepareInfiniteScrollController()
        self.paginationHelper = PaginationHelper(totalCount: player.count, currentCount: self.tableModel.players.count) // MARK: INIT PAGER
        self.endRefreshing()
    }
    
    func onFetchFailure(error: Error) {
        Print.m(error)
        self.endRefreshing()
    }
    
    func onRequestAddPlayerToTeamSuccess(soloLeague: SoloLeague) {
        Print.m("success add player to team")
        //        teamController.addPlayerById(id: team.id, player: tableModel.players.people[currentId])
        if let team = soloLeague.league.teams!.filter({ liTeam -> Bool in
            return liTeam.id == team.id
        }).first {
//            Print.m(team.players.map({ "player id = \($0.first?.person?.getId()). \($0.inviteStatus) " }))
            var convertedPlayers: [Person] = []
            // DEPRECATED: team players do not contains
//            for i in 0..<team.players.count ?? 0 {
//                convertedPlayers.append(team.players[i]/*.convertToPlayer()*/)
//            }
//            teamController.setPlayersByTeamId(id: team.id, players: convertedPlayers)
//            leagueController.setTeamPlayersById(teamId: team.id, players: convertedPlayers)
            
            self.team = team
        }
        
        self.tableView.beginUpdates()
        let indexPath = IndexPath(row: currentAddId!, section: 0)
        tableView.deleteRows(at: [indexPath], with: .left)
        tableView.insertRows(at: [indexPath], with: .right)
        self.tableView.endUpdates()
    }
    
    func onFetchQueryPersonsSuccess(players: [Person]) {
        // asd
//        Print.m(players)
        filteredPlayers = players
        tableView.reloadData()
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
    
    func onFetchPersonsSuccess(players: [Person]) {
        self.setState(state: .normal)
        if tableModel.players.count == 0 {
            tableModel.players = players
        } else {
            tableModel.players.append(contentsOf: players)
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
        return tableModel.players.count// + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! CommandAddPlayerTableViewCell
        
        // DEPRECATED: invite status is deprecated
//        func setupStatus(person: Person) {
//            if leagueController.league.teams!.contains(where:  { team -> Bool in
//                return team.id == self.team.id
//            }) {
//                if self.team.players!.contains(where: { player -> Bool in
//                    return player.person?.getId() ?? player.person?.getValue()?.id ?? "" == person.id
//                }) {
//                    let player = leagueController.getPlayerById(person.id)
//                    if player?.inviteStatus == InviteStatus.accepted.rawValue {
//                        cell.configure(with: person, status: .plyedIn(Texts.IN_YOUR_TEAM))
//                    }
//                    if player?.inviteStatus == InviteStatus.pending.rawValue {
//                        cell.configure(with: person, status: .invitedIn(Texts.INVITED_INTO_YOUR_TEAM))
//                    }
//                } else {
//                    Print.m("user is \(person.getFullName()) not used ")
//                    cell.configure(with: person, status: .notUsed)
//                }
//            }
//        }
        
        let player: Person
        if isFiltering() {
            player = filteredPlayers[indexPath.row]
            
//            setupStatus(person: player)
            
            cell.cell_add_player_btn.tag = indexPath.row
            cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
        } else {
            player = tableModel.players[indexPath.row]
            
//            setupStatus(person: player)
            
            cell.cell_add_player_btn.tag = indexPath.row
            cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
            cell.tag = indexPath.row
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
