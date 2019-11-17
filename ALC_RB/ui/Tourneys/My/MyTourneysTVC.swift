//
//  MyTourneysTVC.swift
//  ALC_RB
//
//  Created by ayur on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD

class MyTourneysTVC: UITableViewController {
        
    var viewModel: MyTourneysVM!
//    var hud: MBProgressHUD?
    private let disposeBag = DisposeBag()
    private var tourneyTable: MyTourneysTable!
    private let localTourneys = LocalTourneys()
//    var leagueDetailModel = BehaviorRelay<_LeagueDetailModel>(value: _LeagueDetailModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Мои турниры"
        self.setupViewModel()
        self.setupTourneyTable()
        self.setupBinds()
        self.setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetch()
    }
    
}

// MARK: SETUP

extension MyTourneysTVC {
    
    func setupViewModel() {
        self.viewModel = MyTourneysVM(tourneyApi: TourneyApi(), leagueApi: LeagueApi())
    }
    
    func setupTourneyTable() {
        tourneyTable = MyTourneysTable(cellActions: self)
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(tourneyTable.cellNib, forCellReuseIdentifier: MyTourneyCell.ID)
        tableView.delegate = tourneyTable
        tableView.dataSource = tourneyTable
        tableView.separatorInset = .zero
        tableView.allowsMultipleSelection = false
    }
    
    func setupBinds() {
                
        tableView
            .rx
            .itemSelected
            .subscribe({ indexPath in
                guard let mIndexPath = indexPath.element else { return }
                let cell = self.tableView.cellForRow(at: mIndexPath) as! MyTourneyCell
                
                cell.layoutIfNeeded()
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                }) { completed in
                    if completed {
                        UIView.animate(withDuration: 0.1) {
                            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
                    } else {
                        Print.m("completed = \(completed)")
                    }
                }
        })
            .disposed(by: disposeBag)
        
        viewModel
            .items
            .observeOn(MainScheduler.instance)
            .subscribe({
                guard let items = $0.element else { return }
                self.tourneyTable.dataSource = items
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .loading
            .bind(to: self.rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .bind(to: self.rx.error)
            .disposed(by: disposeBag)
        
        viewModel
            .message
            .bind(to: self.rx.message)
            .disposed(by: disposeBag)
        
        viewModel
            .items
            .map({ $0.count == 0 })
            .bind(to: self.rx.isEmpty)
            .disposed(by: disposeBag)
        
    }
    
    func setupPullToRefresh() {
        let refreshController = UIRefreshControl()
        tableView.refreshControl = refreshController
        
        refreshController.rx
            .controlEvent(.valueChanged)
            .map { _ in !refreshController.isRefreshing}
            .filter { $0 == false }
            .subscribe({ event in
                self.viewModel.fetch()
            }).disposed(by: disposeBag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .map { _ in refreshController.isRefreshing }
            .filter { $0 == true }
            .subscribe({ event in
                refreshController.endRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: ACTION

extension MyTourneysTVC: TableActions {
    func onCellSelected(model: CellModel) {
        if model is LeagueModelItem {
            self.showLeagueDetail(leagueModelItem: model as! LeagueModelItem)
        }
    }
    
    func onHeaderPressed(model: CellModel) {
        if model is LeagueModelItem {
            self.showLeagueDetail(leagueModelItem: model as! LeagueModelItem)
        }
    }
    
    func onHeaderDeletePressed(model: CellModel) {
        if model is TourneyModelItem {
            self.localTourneys.removeTourney((model as! TourneyModelItem).tourney)
            tableView.reloadData()
        }
    }
}

// MARK: HELPER

extension MyTourneysTVC {
    
    func showLoading() {
        if self.hud != nil {
            self.hud?.setToLoadingView()
        } else {
            self.hud = self.showLoadingViewHUD()
        }
    }
    
    func showEmptyViewGoToChooser() {
        if self.hud != nil {
            self.hud?.setToEmptyView(message: Constants.Texts.NO_STARRED_TOURNEYS, detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS, tap: {
                self.showTourneyPicker()
            })
        } else {
            self.hud = showEmptyViewHUD(addTo: self.tableView, message: Constants.Texts.NO_STARRED_TOURNEYS, detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS, tap: {
                self.showTourneyPicker()
            })
        }
    }

}

// MARK: NAVIGATION

extension MyTourneysTVC {
    
    func showLeagueDetail(leagueModelItem: LeagueModelItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LeagueDetailViewController") as! LeagueDetailViewController
        
        var leagueModel = LeagueDetailModel(leagueModelItem.league)
        
//        self.viewModel.fetchLeagueInfo(leagueId: leagueModelItem.league.id, success: { leagueInfo in
//            leagueModel.leagueInfo = leagueInfo
//
//            newViewController.viewModel.leagueDetailModel = BehaviorRelay<LeagueDetailModel>(value: leagueModel)
//
//            self.navigationController?.show(newViewController, sender: self)
//        })
    }
    
    func showTourneyPicker() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TournamentSearchVC") as! TournamentSearchVC
        self.navigationController?.show(newViewController, sender: self)
    }
    
}

// MARK: REACTIVE

extension Reactive where Base: MyTourneysTVC {
    
    internal var isLoading: Binder<Bool> {
        return Binder(self.base) { vc, loading in
            if loading == true {
                vc.showLoading()
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
    internal var error: Binder<Error?> {
        return Binder(self.base) { vc, error in
            guard let mError = error else { return }
            if vc.hud != nil {
                vc.hud?.setToFailureView(detailMessage: mError.localizedDescription, tap: {
                    vc.viewModel.fetch()
                })
            } else {
                vc.hud = vc.showFailureViewHUD(detailMessage: mError.localizedDescription, tap: {
                    vc.viewModel.fetch()
                })
            }
        }
    }
    
    internal var message: Binder<SingleLineMessage?> {
        return Binder(self.base) { vc, message in
            guard let mMessage = message else { return }
            if vc.hud != nil {
                vc.hud?.setToFailureView(detailMessage: mMessage.message, tap: {
                    vc.viewModel.fetch()
                })
            } else {
                vc.hud = vc.showFailureViewHUD(detailMessage: mMessage.message, tap: {
                    vc.viewModel.fetch()
                })
            }
        }
    }
    
    internal var isEmpty: Binder<Bool> {
        return Binder(self.base) { vc, empty in
            if empty == true {
                vc.showEmptyViewGoToChooser()
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
}
