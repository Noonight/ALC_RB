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
    @IBOutlet weak var scroll_view: UIScrollView!
    
    private var refreshController: UIRefreshControl!
    
    private var presenter: TournamentSearchPresenter!
    private var viewModel: TournamentSearchVM!
    private var tournamentSearchTable: TournamentSearchTable!
    let searchController = UISearchController(searchResultsController: nil)
    private var acp: ActionSheetStringPicker?
//    private var tableView_hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupKeyboardObservers()
        self.setupPresenter()
        self.setupViewModel()
        self.setupTable()
        self.setupSearchController()
//        self.setupInfiniteScrollController()
        self.setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshRegions()
        self.refreshData()
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

private extension TournamentSearchVC {
    
    func setupPullToRefresh() {
        self.refreshController = UIRefreshControl()
        self.refreshController.addTarget(self, action: #selector(refreshControllerAction), for: .valueChanged)
        self.scroll_view.refreshControl = self.refreshController
    }
    
//    func setupInfiniteScrollController() {
//        self.table_view.infiniteScrollIndicatorMargin = 40
//        self.table_view.infiniteScrollTriggerOffset = 500
//        self.table_view.addInfiniteScroll { tableView in
////            if self.viewModel.isInfinite == true
////            {
////                Print.m("is infinite is true")
//                self.refreshData()
////            }
////            Print.m("infinite scroll \(self.table_view.isAnimatingInfiniteScroll)")
////            self.presenter.fetchInfScroll(offset: self.paginationH    elper.getCurrentCount())
//        }
//    }
    
    func setupKeyboardObservers() {
        registerForKeyboardWillShowNotification(table_view)
        registerForKeyboardWillHideNotification(table_view)
    }
    
    func setupViewModel() {
        self.viewModel = TournamentSearchVM()
    }
    
    func setupPresenter() {
        self.presenter = TournamentSearchPresenter(tourneyApi: TourneyApi(), regionApi: RegionApi())
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
        self.showACP(sender: sender)
    }
    
}

extension TournamentSearchVC: TableActions {
    func onCellSelected(model: CellModel) {
        switch model {
        case is RegionMy:
            Print.m(model as! RegionMy)
        case is SearchTourneyModelItem:
            self.viewModel.setLocalTourney(tourney: model as! SearchTourneyModelItem)
        default:
            break
        }
    }
    
    func onCellDeselected(model: CellModel) {
        switch model {
        case is SearchTourneyModelItem:
            self.viewModel.setLocalTourney(tourney: model as! SearchTourneyModelItem)
        default:
            break
        }
    }
    
}

// MARK: UI SEARCH BAR DELEGATE

extension TournamentSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBarIsEmpty() == true
        {
            self.viewModel.updateSearchingQuery(newQuery: nil)
        }
        else
        {
            self.viewModel.updateSearchingQuery(newQuery: searchText)
        }
        
        self.refreshData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        view.endEditing(false)
        self.viewModel.updateSearchingQuery(newQuery: nil)
        self.refreshData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return search_bar.text?.isEmpty ?? true
    }
    
}

// MARK: HELPERS

extension TournamentSearchVC {
    
    @objc func refreshControllerAction() {
        self.showLoadingViewHUD()
        self.search_bar.text = nil
        view.endEditing(false)
        self.viewModel.updateSearchingQuery(newQuery: nil)
        self.viewModel.updateChoosenRegion(newRegion: nil)
        self.region_btn.titleLabel?.text = self.makeButtonTitle(regionName: "Вcе")
        
        self.refreshRegions()
        self.refreshData()
    }
    
    // MARK: REFRESH DATA
    
    func refreshRegions() {
        region_btn.showLoading()
        
        self.presenter?.fetchRegions(success: { regions in
            
            self.region_btn.hideLoading()
            
            self.viewModel?.updateRegions(newRegions: regions)
            
        }, r_message: { r_message in
            
            self.region_btn.hideLoading()
            self.showAlert(title: Constants.Texts.NOTHING, message: r_message.message)
            
        }, r_error: { error in
            
            self.region_btn.hideLoading()
            self.showAlert(title: Constants.Texts.FAILURE, message: error.localizedDescription)
            
        })
    }
    
    func refreshData() {
        // check mbprogress hud inside view
//        if self.tableView_hud == nil
//        {
//            self.tableView_hud = self.showLoadingViewHUD(addTo: self.table_view)
//        }
//        self.showLoadingViewHUD(addTo: self.table_view)
        Print.m("offset is \(self.viewModel.prepareOffset())")
        self.presenter?.fetchTourneys(name: self.viewModel.prepareSearchingQuery(), region: self.viewModel.prepareChoosedRegion(), limit: Constants.Values.LIMIT, offset: self.viewModel.prepareOffset(), success: { tourneys in

            self.hideHUD()
            
            self.viewModel?.updateTourneys(tourneys: tourneys)
            self.tournamentSearchTable?.dataSource = self.viewModel.prepareTourneyMIs()
            
            if self.tournamentSearchTable.dataSource.count == 0
            {
                let imageView = UIImageView(image: UIImage(named: "not"))
                imageView.contentMode = .scaleAspectFit
//                self.tableView_hud?.setToCustomView(with: imageView)
                self.hud?.setToCustomView(with: imageView)
            }
            else
            {
                self.table_view.reloadData()
//                self.tableView_hud?.hide(animated: true)
//                self.tableView_hud = nil
                self.hideHUD()
            }
            
            self.refreshController.endRefreshing()
            
        }, r_message: { r_message in
            
//            self.hideHUD()
            
//            self.tableView_hud?.hide(animated: true)
//            self.tableView_hud = nil
            self.hideHUD()
            self.showAlert(message: r_message.message)
            
        }, r_error: { error in
            
//            self.hideHUD()
            
//            self.tableView_hud?.hide(animated: true)
//            self.tableView_hud = nil
//            self.tableView_hud = self.showEmptyViewHUD(addTo: self.table_view) {
//                self.refreshData()
//            }
            self.hud?.hideHUD()
            self.hud = self.showEmptyViewHUD(addTo: self.table_view, tap: {
                self.refreshData()
            })
        })
    }
    
    // MARK: REGION PICKER
    
    private func makeButtonTitle(regionName: String) -> String {
        return "Регион: \(regionName)"
    }
    
    // MARK: SHOW Aciton Sheet Picker
    
    func showACP(sender: UIButton) {
        self.acp = ActionSheetStringPicker(title: "", rows: self.viewModel?.prepareRegions().map { regionMy -> String in
            return regionMy.name!
            }, initialSelection: 0, doneBlock: { (picker, index, value) in
            
            if let choosedRegion = self.viewModel?.findRegionByName(name: value as! String) {
                
                self.viewModel?.updateChoosenRegion(newRegion: choosedRegion)
                
                sender.setTitle(self.makeButtonTitle(regionName: choosedRegion.name!), for: .normal)
                
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
