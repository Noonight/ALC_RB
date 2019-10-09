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
import MBProgressHUD

class TournamentSearchVC: UIViewController {

    enum Texts {
        static let REGION_NOT_FOUND_LOCAL_ERROR = "Регион не найден."
    }
    
    @IBOutlet weak var search_bar: UISearchBar!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var region_btn: ButtonActivity!
    
    private var presenter: TournamentSearchPresenter!
    private var viewModel: TournamentSearchVM!
    private var tournamentSearchTable: TournamentSearchTable!
    let searchController = UISearchController(searchResultsController: nil)
    private var acp: ActionSheetStringPicker?
    private var tableView_hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupKeyboardObservers()
        self.setupPresenter()
        self.setupViewModel()
        self.setupTable()
        self.setupSearchController()
        self.setupInfiniteScrollController()
        
        self.refreshData()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

private extension TournamentSearchVC {
    
    func setupInfiniteScrollController() {
        self.table_view.infiniteScrollIndicatorMargin = 40
        self.table_view.infiniteScrollTriggerOffset = 500
        self.table_view.addInfiniteScroll { tableView in
            self.showAlert(message: "infinity scroll, is animating infinite scroll \(self.table_view.isAnimatingInfiniteScroll)")
//            self.presenter.fetchInfScroll(offset: self.paginationH	elper.getCurrentCount())
        }
    }
    
    func setupKeyboardObservers() {
        registerForKeyboardWillShowNotification(table_view)
        registerForKeyboardWillHideNotification(table_view)
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
        
        search_bar.delegate = self
        search_bar.showsCancelButton = true
        
    }
    
}

// MARK: ACTIONS

extension TournamentSearchVC {
    
    @IBAction func regionAction(_ sender: ButtonActivity) {
        showRegionPicker(sender: sender)
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
//                filterContentForQuery(searchController.searchBar.text!)
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

}

// MARK: UI SEARCH BAR DELEGATE

extension TournamentSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBarIsEmpty() == true
        {
            view.endEditing(false)
            self.viewModel.updateSearchingQuery(newQuery: nil)
        }
        else
        {
            self.viewModel.updateSearchingQuery(newQuery: searchText)
        }
        
        self.refreshData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(false)
    }
    
//    func isFiltering() -> Bool {
//        return search_bar.isActive && !searchBarIsEmpty()
//    }
    
    func searchBarIsEmpty() -> Bool {
        return search_bar.text?.isEmpty ?? true
    }
    
}

// MARK: HELPERS

extension TournamentSearchVC {
    
    // MARK: REFRESH DATA
    
    func refreshData(limit: Int? = Constants.Values.LIMIT, offset: Int? = 0) {
        self.tableView_hud = self.showLoadingViewHUD(addTo: self.table_view)
        
        self.presenter?.fetchTourneys(name: self.viewModel.prepareSearchingQuery(), region: self.viewModel.prepareChoosedRegion(), limit: limit, offset: offset, success: { tourneys in
            self.viewModel?.updateTourneys(tourneys: tourneys)
            self.tournamentSearchTable?.dataSource = self.viewModel.prepareTourneyMIs()
            
//            if self.tournamentSearchTable.dataSource.count == 0
//            {
//                self.tableView_hud?.hide(animated: true)
//                self.tableView_hud = self.showCustomViewHUD(cView: UIImageView(image: UIImage(named: "not")), addTo: self.table_view, detailMessage: "")
//            }
//            else
//            {
                self.table_view.reloadData()
                self.tableView_hud?.hide(animated: true)
//            }
            
        }, r_message: { r_message in
            
            self.tableView_hud?.hide(animated: true)
            self.showAlert(message: r_message.message)
            
        }, localError: { error in
            
            self.tableView_hud?.hide(animated: true)
            self.tableView_hud = self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData()
            }
            
        }, serverError: { error in
            
            self.tableView_hud?.hide(animated: true)
            self.tableView_hud = self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData()
            }
            
        }, alamofireError: { error in
            
            self.tableView_hud?.hide(animated: true)
            self.tableView_hud = self.showEmptyViewHUD(addTo: self.table_view) {
                self.refreshData()
            }
            
        })
    }
    
    // MARK: REGION PICKER
    
    func showRegionPicker(sender: ButtonActivity) {
        
        sender.showLoading()
        
        self.presenter?.fetchRegions(success: { regions in
            
            sender.hideLoading()
            
            self.viewModel?.updateRegions(newRegions: regions)
            
            self.showACP(sender: sender)
            
        }, r_message: { r_message in
            
            sender.hideLoading()
            self.showAlert(title: Constants.Texts.NOTHING, message: r_message.message) {
                self.acp?.hideWithCancelAction()
                self.showRegionPicker(sender: self.region_btn)
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
    
    // MARK: SHOW Aciton Sheet Picker
    
    func showACP(sender: UIButton) {
        self.acp = ActionSheetStringPicker(title: "", rows: self.viewModel?.prepareRegions().map { regionMy -> String in
            return regionMy.name
            }, initialSelection: 0, doneBlock: { (picker, index, value) in
            
            if let choosedRegion = self.viewModel?.findRegionByName(name: value as! String) {
                
                self.viewModel?.updateChoosenRegion(newRegion: choosedRegion)
                
                sender.setTitle(self.makeButtonTitle(regionName: choosedRegion.name), for: .normal)
                
                self.refreshData()
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
            sender.setTitle(self.makeButtonTitle(regionName: "Все"), for: .normal)
            self.viewModel.updateChoosenRegion(newRegion: nil)
            self.refreshData()
        })
        self.acp?.show()
    }
    
}
