//
//  CommandsLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 24.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommandsLKTableViewController: UITableViewController {
    enum CellIdentifiers {
        static let COMMAND = "commands_lk_cell"
    }
    enum SegueIdentifiers {
        static let EDIT = "segue_edit_team"
        static let ADD = "segue_add_team"
    }
    
    @IBOutlet weak var createNewCommandBtn: UIBarButtonItem!
    
    private var viewModel: TeamsLKViewModel!
    private var teamTable: TeamsLKTable!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTable()
        setupBinds()
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = createNewCommandBtn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
}

// MARK: SETUP

extension CommandsLKTableViewController {
    
    func setupViewModel() {
        viewModel = TeamsLKViewModel(teamApi: TeamApi(), inviteApi: InviteApi())
    }
    
    func setupTable() {
        teamTable = TeamsLKTable(dataSource: [], tableActions: self)
        tableView.delegate = teamTable
        tableView.dataSource = teamTable
    }
    
    func setupBinds() {
        
//        tableView.rx.itemSelected.
        
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

// MARK: ACTIONS

extension CommandsLKTableViewController {
    
    @IBAction func onAddCommandBtnPressed(_ sender: UIBarButtonItem) {  }
    
}

extension CommandsLKTableViewController: TableActions {
    func onCellSelected(model: CellModel) {
        Print.m(model)
    }
}

// MARK: Helpers

extension CommandsLKTableViewController {
    
    func showRemoveTeamAlert(teamName: String, delete: @escaping () -> (), cancel: @escaping () -> ()) {
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            delete()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            cancel()
        }
        showAlert(title: "Предупреждение!", message: "Удалить команду '\(teamName)'?", actions: [actionDelete, actionCancel])
    }
}

// MARK: - Navigation
extension CommandsLKTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.EDIT,
            let destination = segue.destination as? CommandEditLKViewController,
            let indexPath = tableView.indexPathForSelectedRow
        {
            assertionFailure("deprecated participation")
        }
        
        if segue.identifier == SegueIdentifiers.ADD,
            let destination = segue.destination as? CommandCreateLKViewController
        {
            
        }
        
    }
}
