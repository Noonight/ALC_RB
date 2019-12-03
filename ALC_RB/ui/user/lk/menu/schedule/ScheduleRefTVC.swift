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

class ScheduleRefTVC: UITableViewController {
    private enum StaticParams {
        static let emptyMessage = "Здесь будут отображаться текущие матчи"
    }
    
    private var viewModel: ScheduleRefViewModel!
    private var scheduleTable: ScheduleRefTable!
    private let bag = DisposeBag()
    
    private lazy var editSchedule: EditScheduleLKViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditScheduleLKViewController") as! EditScheduleLKViewController
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTable()
        setupViewBinds()
        
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

extension ScheduleRefTVC {
    
    func setupViewModel() {
        self.viewModel = ScheduleRefViewModel(matchApi: MatchApi())
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
    
}

// MARK: - ACTIONS

extension ScheduleRefTVC: TableActions {
    func onCellSelected(model: CellModel) {
        if model is MatchScheduleModelItem {
            showEditMatchReferees(model: model as! MatchScheduleModelItem)
        }
    }
}

// MARK: - EDIT SCHEDULE CALL BACK

extension ScheduleRefTVC: EditScheduleCallBack {
    
    func back(match: Match) {
        editSchedule.dismiss(animated: true) {
            Print.m("dismiss here yee")
        }
        self.viewModel.fetch()
    }
    
}

// MARK: - NAVIGATION

extension ScheduleRefTVC {
    
    func showEditMatchReferees(model: MatchScheduleModelItem) {
//        editSchedule.
        editSchedule.editScheduleCallBack = self
        editSchedule.viewModel.matchScheduleModel.accept(model)
        show(editSchedule, sender: self)
    }
    
}
