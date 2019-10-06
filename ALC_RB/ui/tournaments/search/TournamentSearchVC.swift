//
//  TournamentSearchVC.swift
//  ALC_RB
//
//  Created by ayur on 04.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

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
//        self.configureSearchController()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

private extension TournamentSearchVC {
    
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
    }
    
//    func setupSearchController() {
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

// MARK: ACTIONS

extension TournamentSearchVC {
    
    @IBAction func regionAction(_ sender: UIButton) {
        Print.m("show region menu")
        
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


// MARK: HELPERS

extension TournamentSearchVC {
    
    func showRefereesPicker(sender: ButtonActivity) {
        
        // show button's activity indicator
        sender.showLoading()
        
        self.presenter?.fetchRegions(success: { regions in
            
            // hide button's activity indicator
            sender.hideLoading()
            
            self.viewModel?.updateRegions(newRegions: regions)
            
            self.acp = ActionSheetStringPicker(title: sender.titleLabel?.text, rows: self.viewModel?.prepareRegions().map { regionMy -> String in
                return regionMy.name
            }, initialSelection: 0, doneBlock: { (picker, index, value) in
                
                if let choosedRegion = self.viewModel?.findRegionByName(name: value as! String) {
                    
                    self.viewModel?.updateChoosenRegion(newRegion: choosedRegion)
                    
                    sender.setTitle(choosedRegion.name, for: .normal)
                }
                else
                {
                    self.acp?.hideWithCancelAction()
                    self.showAlert(message: Texts.REGION_NOT_FOUND_LOCAL_ERROR)
                }
            }, cancel: { (picker) in
                Print.m("acp cancel")
            }, origin: sender)
            
            self.acp?.show()
            
        }, r_message: { r_message in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.NOTHING, message: r_message.message)
            
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
        
//        acp?.addCustomButton(withTitle: "Снять", actionBlock: {
//            sender.setTitleAndColorWith(title: Texts.NO_REF, color: Colors.NO_REF)
//        })
    }
    
}
