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

class TeamsLKTVC: UITableViewController {
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
        
        viewModel.fetch()
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

extension TeamsLKTVC {
    
    func setupViewModel() {
        viewModel = TeamsLKViewModel(leagueApi: LeagueApi(), teamApi: TeamApi(), inviteApi: InviteApi())
    }
    
    func setupTable() {
        teamTable = TeamsLKTable(tableActions: self)
        tableView.delegate = teamTable
        tableView.dataSource = teamTable
    }
    
    func setupBinds() {
        
//        tableView.rx.itemSelected.
        
        viewModel
            .teamOwnerVM
            .ownerTeams
            .subscribe { items in
                self.teamTable.dataSource.items.append(contentsOf: items.element!)
                self.tableView.reloadSections(IndexSet(integersIn: 0...0), with: UITableView.RowAnimation.fade)
            }.disposed(by: bag)
        
        viewModel
            .teamInVM
            .inTeams
            .observeOn(MainScheduler.instance)
            .subscribe { items in
                self.teamTable.dataSourceNotMy.items = items.element!
                self.tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
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

// MARK: ACTIONS

extension TeamsLKTVC {
    
    @IBAction func onAddCommandBtnPressed(_ sender: UIBarButtonItem) {
        self.showCreateTeam()
    }
    
}

extension TeamsLKTVC: TableActions {
    
    func onCellSelected(model: CellModel, closure: @escaping () -> ()) {
        if model is TeamModelItem {
//            self.showEditTeam(teamModelItem: model as! TeamModelItem)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//                closure()
//            }
            self.viewModel.teamEditVM.team.accept((model as! TeamModelItem).team)
            self.viewModel.teamEditVM.fetchTeamPlayerStatuses {
                self.showEditTeam(teamModelItem: model as! TeamModelItem)
                closure()
            }
//            closure()
        }
    }
    
    func onCellDelete(indexPath: IndexPath, model: CellModel) {
        if model is TeamModelItem {
            self.showRemoveTeamAlert(model: model as! TeamModelItem, delete: {
                self.tableView.beginUpdates()
                
                // TODO: request for delete. And after delete data
                self.teamTable.dataSource.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                
                self.tableView.endUpdates()
            }) {
                Print.m("Cancel delete")
            }
        }
    }
}

// MARK: HELPERS

extension TeamsLKTVC {
    
    func showRemoveTeamAlert(model: TeamModelItem, delete: @escaping () -> (), cancel: @escaping () -> ()) {
        let actionDelete = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            delete()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            cancel()
        }
        showAlert(title: "Предупреждение!", message: "Удалить команду '\(model.name!)'?", actions: [actionDelete, actionCancel])
    }
}

extension TeamsLKTVC: CreateTeamCallBack {
    func back(team: Team) {
//        Print.m("Team \(team) is created")
        self.navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = createNewCommandBtn
        self.viewModel.fetch()
    }
}

// MARK: - NAVIGATION

extension TeamsLKTVC {

    func showEditTeam(teamModelItem: TeamModelItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommandEditLKViewController") as! TeamEditLKVC
        newViewController.viewModel = self.viewModel.teamEditVM
        self.navigationController?.show(newViewController, sender: self)
//        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    func showCreateTeam() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CommandCreateLKViewController") as! TeamCreateLKVC
        newViewController.callBack = self
        
//        self.show(newViewController, sender: self)
//        self.navigationController?.show(newViewController, sender: self)
        self.navigationController?.show(newViewController, sender: self)
//        self.navigationController.
//        self.navigationController?.show(newViewController, sender: self)
        
//        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
}
