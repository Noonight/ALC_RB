//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ScheduleTVC: UITableViewController {
    private enum StaticParams {
        static let emptyMessage = "Здесь будут отображаться текущие матчи"
    }
    
    private var viewModel: ScheduleViewModel!
    private var scheduleTable: ScheduleRefTable!
    private let bag = DisposeBag()
    
    private lazy var assignReferees: AssignRefereesVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditScheduleLKViewController") as! AssignRefereesVC
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTable()
        setupViewBinds()
        setupPullToRefresh()
        
        emptyAction = {
            self.hideHUD()
            self.hud = nil
            self.viewModel.fetch()
        }
        errorAction = {
            self.hideHUD()
            self.hud = nil
            self.viewModel.fetch()
        }
        
        viewModel.fetch()
        
    }
    
}

// MARK: - SETUP

extension ScheduleTVC {
    
    func setupViewModel() {
        self.viewModel = ScheduleViewModel(matchApi: MatchApi())
    }
    
    func setupTable() {
        self.scheduleTable = ScheduleRefTable(tableActions: self)
        self.tableView.delegate = scheduleTable
        self.tableView.dataSource = scheduleTable
    }
    
    func setupViewBinds() {
        
        viewModel
            .groupedMatches
            .observeOn(MainScheduler.instance)
            .subscribe { elements in
                guard let groupedMatches = elements.element else { return }
                self.scheduleTable.dataSource = groupedMatches
                self.tableView.reloadData()
            }.disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.message)
            .disposed(by: bag)
        
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
            }).disposed(by: bag)
        
        refreshController.rx.controlEvent(.valueChanged)
            .map { _ in refreshController.isRefreshing }
            .filter { $0 == true }
            .subscribe({ event in
                refreshController.endRefreshing()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - ACTIONS

extension ScheduleTVC: TableActions {
    func onCellSelected(model: CellModel) {
        if model is MatchScheduleModelItem {
            showEditMatchReferees(model: model as! MatchScheduleModelItem)
        }
    }
}

// MARK: - EDIT SCHEDULE CALL BACK

extension ScheduleTVC: AssignRefereesCallBack {
    func assignRefereesBack(match: Match) {
        navigationController?.popViewController(animated: true)
        self.viewModel.fetch()
    }
}

// MARK: - NAVIGATION

extension ScheduleTVC {
    
    func showEditMatchReferees(model: MatchScheduleModelItem) {
//        editSchedule.
        assignReferees.assignRefereesCallBack = self
        assignReferees.viewModel = AssignRefereesViewModel(matchApi: MatchApi())
        assignReferees.viewModel.match.accept(model.match)
//        editSchedule.viewModel.initReferees()
        show(assignReferees, sender: self)
    }
    
}
