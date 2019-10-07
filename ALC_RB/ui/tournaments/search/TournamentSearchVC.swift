//
//  TournamentSearchVC.swift
//  ALC_RB
//
//  Created by ayur on 04.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire

class TournamentSearchVC: UIViewController {

    enum Texts {
        static let REGION_NOT_FOUND_LOCAL_ERROR = "Регион не найден."
    }
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var region_btn: ButtonActivity!
    
    private var presenter: TournamentSearchPresenter?
    private var viewModel: TournamentSearchVM?
    private var tournamentSearchTable: TournamentSearchTable?
    let searchController = UISearchController(searchResultsController: nil)
    private var acp: ActionSheetStringPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        self.setupViewModel()
        self.setupTable()
        self.setupSearchController()
        
        self.refreshData(name: nil)
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

private extension TournamentSearchVC {
    
    func setupInfiniteScrollController() {
        self.table_view.infiniteScrollIndicatorMargin = 40
        self.table_view.infiniteScrollTriggerOffset = 500
        self.table_view.addInfiniteScroll { tableView in
//            self.presenter.fet
//            self.presenter.fetchInfScroll(offset: self.paginationHelper.getCurrentCount())
        }
    }
    
    func setupViewModel() {
        self.viewModel = TournamentSearchVM()
    }
    
    func setupPresenter() {
        self.presenter = TournamentSearchPresenter(dataManager: ApiRequests())
    }
    
    func setupTable() {
        self.tournamentSearchTable = TournamentSearchTable(actions: self)
        self.table_view.delegate = self.tournamentSearchTable
        self.table_view.dataSource = self.tournamentSearchTable
        self.table_view.register(self.tournamentSearchTable?.cellNib, forCellReuseIdentifier: TournamentSearchTableViewCell.ID)
        
        self.table_view.allowsMultipleSelection = true
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск Турниров"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            table_view.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
}

// MARK: ACTIONS

extension TournamentSearchVC {
    
    @IBAction func regionAction(_ sender: ButtonActivity) {
        Print.m("show region menu")
        showRefereesPicker(sender: sender)
    }
    
}

extension TournamentSearchVC: CellActions {
    func onCellSelected(model: CellModel) {
        switch model {
        case is RegionMy:
            Print.m(model as! RegionMy)
        default:
            break
        }
    }
    
    
}

// MARK: SEARCH CONTROLLER

extension TournamentSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.table_view.removeInfiniteScroll()
//            self.refreshControl = nil
            if searchController.searchBar.text?.count ?? 0 > 2 {
                filterContentForQuery(searchController.searchBar.text!)
            } else {
//                filteredPlayers.people = []
                table_view.reloadData()
            }
            Print.m("search controller is active")
        } else {
            Print.m("search controller is not active")
            self.table_view.reloadData()
            // configure deleted interacive features
//            self.setupPullToRefresh()
//            self.configureInfiniteScrollController()

        }
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForQuery(_ query: String, scope: String = "All") {
        self.refreshData(name: query)
        //        if searchBarIsEmpty() {
        //            self.filteredPlayers = Players()
        //        }
//        self.presenter.searchPlayers(query: query)
        //        if query.count >= 2 {
        //            presenter.searchPlayers(query: query)
        //        }
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

// MARK: HELPERS

extension TournamentSearchVC {
    
    func refreshData(name: String?, limit: Int? = 20, offset: Int? = 0) {
        
//        self.showLoadingViewHUD(addTo: self.table_view)
        self.showLoadingViewHUD(addTo: self.table_view)
        
        self.presenter?.fetchTourneys(name: name, limit: limit, offset: offset, success: { tourneys in
//            Print.m(tourneys)
            self.viewModel?.updateTourneys(tourneys: tourneys)
            self.tournamentSearchTable?.dataSource = self.viewModel?.prepareTourneysMI() ?? []
            
            self.table_view.reloadData()
//            self.hideHUD(for: self.table_view)
            self.hideHUD(forView: self.table_view)
            
//            Print.m(self.tournamentSearchTable?.dataSource)
        }, r_message: { r_message in
            
            self.hideHUD()
            self.showAlert(message: r_message.message)
            
        }, localError: { error in
            
            self.hideHUD(forView: self.table_view)
            self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData(name: nil)
            }
            
        }, serverError: { error in
            
            self.hideHUD(forView: self.table_view)
            self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData(name: nil)
            }
            
        }, alamofireError: { error in
            
            self.hideHUD(forView: self.table_view)
            self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData(name: nil)
            }
            
        })
    }
    
    func showRefereesPicker(sender: ButtonActivity) {
        
        // show button's activity indicator
        sender.showLoading()
        
        self.presenter?.fetchRegions(success: { regions in
            
            // hide button's activity indicator
            sender.hideLoading()
            
            self.viewModel?.updateRegions(newRegions: regions)
            
            self.acp = ActionSheetStringPicker(title: "", rows: self.viewModel?.prepareRegions().map { regionMy -> String in
                return regionMy.name
                }, initialSelection: 0, doneBlock: { (picker, index, value) in
                
                if let choosedRegion = self.viewModel?.findRegionByName(name: value as! String) {
                    
                    self.viewModel?.updateChoosenRegion(newRegion: choosedRegion)
                    
                    sender.setTitle(self.makeButtonTitle(regionName: choosedRegion.name), for: .normal)
                }
                else
                {
                    self.acp?.hideWithCancelAction()
                    self.showAlert(message: Texts.REGION_NOT_FOUND_LOCAL_ERROR)
                }
            }, cancel: { (picker) in
                Print.m("acp cancel")
            }, origin: sender)
            
            self.acp?.addCustomButton(withTitle: "Все регионы", actionBlock: {
                sender.setTitle("Все", for: .normal)
            })
            
            self.acp?.show()
            
        }, r_message: { r_message in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.NOTHING, message: r_message.message) {
                self.acp?.hideWithCancelAction()
                self.showRefereesPicker(sender: self.region_btn)
            }
            
        }, localError: { error in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription)
            
        }, serverError: { error in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.SERVER_FAILURE, message: error.localizedDescription)
            
        }, alamofireError: { error in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription)
            
        })
    }
    
    private func makeButtonTitle(regionName: String) -> String {
        return "Регион : \(regionName)"
    }
    
}
