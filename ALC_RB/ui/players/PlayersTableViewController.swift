//
//  PlayersTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PlayersTableViewController: BaseStateTableViewController {
    private enum CellIdentifiers {
        static let PLAYER = "cell_players"
    }
    private enum SegueIdentifiers {
        static let PLAYER = "segue_player"
    }
    
    // MARK: Var & Let
    
    let presenter = PlayersPresenter()
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    var paginationHelper: PaginationHelper!
    
    var players = Players()
    var filteredPlayers = Players()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePresenter()
        self.configureSearchController()
        self.configureTableView()
        self.configureRefreshController()
        self.configureInfiniteScrollController()
        
        self.refreshData()
    }
    
    // MARK: Configure
    func configureRefreshController() {
        self.fetch = self.presenter.fetch
    }
    func configureInfiniteScrollController() {
        self.tableView.infiniteScrollIndicatorMargin = 40
        self.tableView.infiniteScrollTriggerOffset = 500
        self.tableView.addInfiniteScroll { tableView in
            self.presenter.fetchInfScroll(offset: self.paginationHelper.getCurrentCount())
        }
    }
    func configurePresenter() {
        self.initPresenter()
    }
    func configureTableView() {
        self.tableView.tableFooterView = UIView()
    }
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
}

// MARK: Extensions

// MARK: Refresh controller

extension PlayersTableViewController {
    override func hasContent() -> Bool {
        if self.players.people.count == 0 {
            return false
        } else {
            return true
        }
    }
}

// MARK: Presenter

extension PlayersTableViewController: PlayersTableView {
    func onFetchSuccess(players: Players) {
        self.players = players
        // if pull to refresh used pages also update
        self.configureInfiniteScrollController()
        self.paginationHelper = PaginationHelper(totalCount: players.count, currentCount: self.players.people.count) // MARK: INIT PAGER
        self.endRefreshing()
    }
    
    func onFetchFailure(error: Error) {
        Print.m(error)
        self.endRefreshing()
    }
    
    func onFetchScrollSuccess(players: Players) {
        Print.m("new players count is \(self.players.people.count + players.people.count)")
        // create new index paths
        let playersCount = self.players.people.count // current count of players
        let responsePlayersCount = players.people.count + playersCount // current count of response players
        let (start, end) = (playersCount, responsePlayersCount)
        let indexPaths = (start..<end).map { return IndexPath(row: $0, section: 0) }
        
        // update data source
        self.players.people.append(contentsOf: players.people)
        self.paginationHelper.setCurrentCount(newCount: self.players.people.count)
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
    
    func onRequestQueryPersonsSuccess(players: Players) {
        filteredPlayers = players
        tableView.reloadData()
    }
    
    func onRequestQueryPersonsFailure(error: Error) {
        // some
//        let alert = UIAlertController(title: "\(error.localizedDescription)", message: nil, preferredStyle: .alert)
//        present(alert, animated: true) {
////            alert.dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        }
        Print.m(error)
        showAlert(message: error.localizedDescription)
    }
    
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getPlayers()
    }
    
    func onGetPlayersSuccess(_ players: Players) {
        self.players = players
    }
}

// MARK: Table view

extension PlayersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFiltering()) {
            return filteredPlayers.people.count
        }
        return players.people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PLAYER, for: indexPath) as! PlayerTableViewCell
        
        let player: Person
        if (isFiltering()) {
            player = filteredPlayers.people[indexPath.row]
        } else {
            player = players.people[indexPath.row]
        }
        
        configureCell(cell, player)
        
        return cell
    }
    
    func configureCell(_ cell: PlayerTableViewCell, _ player: Person) {
//        let fullName = player.surname + " " + player.name
//
//        if (fullName.count > 3) {
//            cell.mName.text = fullName
//        } else {
//            cell.mName.text = "Не указано"
//        }
        cell.mName.text = player.getSurnameNP()
        
        cell.mBirthDate.text = player.birthdate.toFormat(DateFormats.local.rawValue)
        
        if player.photo?.count ?? 0 != 0 {
            let url = ApiRoute.getImageURL(image: player.photo!)
            let processor = DownsamplingImageProcessor(size: cell.mImage.frame.size)
                .append(another: CroppingImageProcessorCustom(size: cell.mImage.frame.size))
                .append(another: RoundCornerImageProcessor(cornerRadius: cell.mImage.getHalfWidthHeight()))
            
            cell.mImage.kf.indicatorType = .activity
            cell.mImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "ic_logo"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            cell.mImage.image = UIImage(named: "ic_logo")
        }
    }
}
// MARK: Table view DELEGATE
extension PlayersTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: Search controller
extension PlayersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.tableView.removeInfiniteScroll()
            self.refreshControl = nil
            if searchController.searchBar.text?.count ?? 0 > 2 {
                filterContentForQuery(searchController.searchBar.text!)
            } else {
                filteredPlayers.people = []
                tableView.reloadData()
            }
            Print.m("search controller is active")
        } else {
            Print.m("search controller is not active")
            self.tableView.reloadData()
            // configure deleted interacive features
            self.setupPullToRefresh()
            //            self.prepareRefreshController()
            self.configureInfiniteScrollController()
            
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForQuery(_ query: String, scope: String = "All") {
//        if searchBarIsEmpty() {
//            self.filteredPlayers = Players()
//        }
        self.presenter.searchPlayers(query: query)
//        if query.count >= 2 {
//            presenter.searchPlayers(query: query)
//        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
// MARK: Navigation
extension PlayersTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifiers.PLAYER,
            let destination = segue.destination as? PlayerViewController,
            let indexPath = tableView.indexPathForSelectedRow,
            let cellIndex = tableView.indexPathForSelectedRow?.row
        {
            let person: Person
            if isFiltering() {
                person = filteredPlayers.people[cellIndex]
            } else {
                person = players.people[cellIndex]
            }
            
            let cacheImage = ImageCache.default
//            var cachedOriginalSizeImage: UIImage?

            if let imageUrl = players.people[cellIndex].photo {
//                cell.showLoading()
                cacheImage.retrieveImage(forKey: ApiRoute.getAbsoluteImageRoute(imageUrl)) { result in
                    switch result {
                    case .success(let value):
                        if let image = value.image {
                            destination.content = PlayerViewController.PlayerDetailContent(person: person, photo: value.image!)
                        } else {
                            destination.content = PlayerViewController.PlayerDetailContent(person: person, photo: nil)
                        }
                    case .failure(let error):
                        print(error)
                        destination.content = PlayerViewController.PlayerDetailContent(person: person, photo: nil)
                    }
                }
            } else {
                destination.content = PlayerViewController.PlayerDetailContent(person: person, photo: nil)
            }
            
//            destination.content = PlayerViewController.PlayerDetailContent(
//                person: person, photo: cell.mImage.image!
//            )
        }
    }
}
