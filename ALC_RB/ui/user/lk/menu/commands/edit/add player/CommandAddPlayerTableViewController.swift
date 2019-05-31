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
    
    struct TableModel {
        var players = Players()
        
        init() {}
        
        init(players: Players) {
            self.players = players
        }
    }
    
    let userDefaultsHelper = UserDefaultsHelper()
    var team = Team()
    var leagueId: String!
    
    let searchController = UISearchController(searchResultsController: nil)
    var currentTimeOfSearch = CACurrentMediaTime()
    
    var tableModel = TableModel() {
        didSet {
            updateUI()
        }
    }
    var filteredPlayers = Players()
    
    let presenter = CommandAddPlayerPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
        presenter.fetchPersons(offset: 0)
        
        configureSearchController()
        
        tableView.tableFooterView = UIView()
//        let loadingCellNib = UINib.init(nibName: LoadingCell.NibParams.nibName, bundle: nil)
//        self.tableView.register(loadingCellNib, forCellReuseIdentifier: CellIdentifiers.loading)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tableModel.players.people.count < 2 {
            setState(state: .loading)
            searchController.searchBar.text = ""
            searchController.isActive = false
            presenter.fetchPersons(offset: currentCount())
        }
    }

    // MARK: - Helpers

    func configureSearchController() {
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
    
    func updateUI() {
//        DispatchQueue.main.async {
            self.tableView.reloadData()
//        }
//        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPlayers.count
        }
        return tableModel.players.people.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if isLoadingCell(for: indexPath) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loading, for: indexPath) as! LoadingCell
//            return cell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! CommandAddPlayerTableViewCell
        
        let player: Person
        if isFiltering() {
            player = filteredPlayers.people[indexPath.row]
            cell.configure(with: player)
            
            cell.cell_add_player_btn.tag = indexPath.row
            cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
        } else {
            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
                //            cell.backAction = self
                //            cell.cell_loadMore_btn.addTarget(self, action: #selector(onLoadMoreBtnPressed(sender:)), for: .touchUpInside)
                cell.cell_loadMore_btn.addTarget(self, action: #selector(onLoadMoreBtnPressed), for: .touchUpInside)
                
            } else {
                player = tableModel.players.people[indexPath.row]
                
                cell.configure(with: player)
                cell.cell_add_player_btn.tag = indexPath.row
                cell.cell_add_player_btn.addTarget(self, action: #selector(onAddPlayerBtnPressed), for: .touchUpInside)
                cell.tag = indexPath.row
            }
        }
//        cell.configure(with: tableModel.players.people[indexPath.row])
        
        return cell
    }
    
    // it is for add player to team
    var currentAddId: Int?
    
    @objc func onAddPlayerBtnPressed(sender: UIButton) {
        var personId: String!
        if isFiltering() {
            personId = filteredPlayers.people[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(filteredPlayers.people[sender.tag])")
        } else {
            personId = tableModel.players.people[sender.tag].id
            Print.m("tag of button is \(sender.tag). item on this tag is \(tableModel.players.people[sender.tag])")
        }
        presenter.addPlayerToTeamForLeague(token: userDefaultsHelper.getAuthorizedUser()!.token, addPlayerToTeam: AddPlayerToTeam(
            _id: leagueId,
            teamId: team.id,
            playerId: personId)
        )
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Print.m("cell did select")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

//extension CommandAddPlayerTableViewController : CommandAddPlayerViewModelDelegate {
//    func onFetchPersonsCompleted(with newIndexPathsToReload: [IndexPath]?) {
//        guard let newIndexPathsToReload = newIndexPathsToReload else {
////            indicatorView.stopAnimating()
//            setState(state: .normal)
////            tableView.isHidden = false
////            tableView.reloadData()
//            return
//        }
//        // 2
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
//    }
//
//    func onFetchPersonsFailed(with error: Error) {
////        indicatorView.stopAnimating()
//        setState(state: .error(message: "Warning: \(error)"))
////        let title = "Warning".localizedString
////        let action = UIAlertAction(title: "OK".localizedString, style: .default)
////        displayAlert(with: title , message: reason, actions: [action])
//    }
//
//
//}

//extension CommandAddPlayerTableViewController : UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        Print.m("index path is loading \(indexPaths)")
//        if indexPaths.contains(where: isLoadingCell) {
//            Print.m("Index path containts is loading cell")
//            viewLoaded.fetchPersons(offset: viewModel.offset)
//        }
//    }
//}

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
        updateUI()
//        }
    }
    
    func isFiltering() -> Bool {
        let isFilter = searchController.isActive && !searchBarIsEmpty()
        return isFilter
    }
    
    
    func saveCurrentTime() {
        currentTimeOfSearch = CACurrentMediaTime()
        
        
    }
}

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

extension CommandAddPlayerTableViewController : CommandAddPlayerView {
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
    
    func onRequestAddPlayerToTeamSuccess(singleLineMessage: SingleLineMessage) {
        deleteLastChosenRow()
//        showToast(message: "add player to team good")
    }
    
    func onRequestAddPlayerToTeamFailure(singleLineMessage: SingleLineMessage) {
        // somwthing
        showToast(message: "Ошибка: \(singleLineMessage.message)")
    }
    
    func onRequestAddPlayerToTeamError(error: Error) {
        showToast(message: "Неизвестная ошибка.")
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
    
//    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
//        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
//        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
//        return Array(indexPathsIntersection)
//    }
}
