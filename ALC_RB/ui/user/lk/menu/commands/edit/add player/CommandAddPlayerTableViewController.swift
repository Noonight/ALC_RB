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
//        var team = Team()
//        var players: [Player] = []
//        var persons: [Person] = []
//
//        init() {}
//
//        init(team: Team, players: [Player]) {
//            self.team = team
//            self.players = players
//        }
//
//        init(team: Team, players: [Player], persons: [Person]) {
//            self.team = team
//            self.players = players
//            self.persons = persons
//        }
        var players = Players()
        
        init() {}
        
        init(players: Players) {
            self.players = players
        }
    }
    
    var tableModel = TableModel() {
        didSet {
            updateUI()
        }
    }
    
    let presenter = CommandAddPlayerPresenter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        
//        let loadingCellNib = UINib.init(nibName: LoadingCell.NibParams.nibName, bundle: nil)
//        self.tableView.register(loadingCellNib, forCellReuseIdentifier: CellIdentifiers.loading)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setState(state: .loading)
        
        presenter.fetchPersons(offset: 0)
    }

    // MARK: - Helpers
    
    func updateUI() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.players.people.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if isLoadingCell(for: indexPath) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.loading, for: indexPath) as! LoadingCell
//            return cell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! CommandAddPlayerTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
//            cell.backAction = self
//            cell.cell_loadMore_btn.addTarget(self, action: #selector(onLoadMoreBtnPressed(sender:)), for: .touchUpInside)
            cell.cell_loadMore_btn.addTarget(self, action: #selector(onLoadMoreBtnPressed), for: .touchUpInside)

        } else {
            cell.configure(with: tableModel.players.people[indexPath.row])
        }
        
//        cell.configure(with: tableModel.players.people[indexPath.row])
        
        return cell
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
}

extension CommandAddPlayerTableViewController : CommandAddPlayerView {
    func onFetchPersonsSuccess(players: Players) {
        self.setState(state: .normal)
        if tableModel.players.count == 0 {
            tableModel.players = players
        }
        tableModel.players.people.append(contentsOf: players.people)
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
