//
//  TournamentSearchVC.swift
//  ALC_RB
//
//  Created by ayur on 04.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TournamentSearchVC: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    
//    private var tournamentSearchTable: TournamentSearchTable?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.configureSearchController()
    }
}

// MARK: EXTENSIONS


// MARK: SETUP

extension TournamentSearchVC {
    
//    func configureSearchController() {
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Поиск игроков"
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//        } else {
//            table_view.tableHeaderView = searchController.searchBar
//            // Fallback on earlier versions
//        }
//        definesPresentationContext = true
//    }
    
}


// MARK: SEARCH CONTROLLER

//extension TournamentSearchVC: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if searchController.isActive {
//            self.table_view.removeInfiniteScroll()
//            self.refreshControl = nil
//            if searchController.searchBar.text?.count ?? 0 > 2 {
//                filterContentForQuery(searchController.searchBar.text!)
//            } else {
//                filteredPlayers.people = []
//                table_view.reloadData()
//            }
//            Print.m("search controller is active")
//        } else {
//            Print.m("search controller is not active")
//            self.table_view.reloadData()
//            // configure deleted interacive features
//            self.setupPullToRefresh()
//            //            self.prepareRefreshController()
//            self.configureInfiniteScrollController()
//
//        }
//    }
//
//    func searchBarIsEmpty() -> Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//
//    func filterContentForQuery(_ query: String, scope: String = "All") {
//        //        if searchBarIsEmpty() {
//        //            self.filteredPlayers = Players()
//        //        }
//        self.presenter.searchPlayers(query: query)
//        //        if query.count >= 2 {
//        //            presenter.searchPlayers(query: query)
//        //        }
//    }
//
//    func isFiltering() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }
//
//}
