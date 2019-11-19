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
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
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
    
    func setupBinds() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        
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

// MARK: Table view
extension CommandsLKTableViewController {
    // MARK: Data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableModel.headerTitleForSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.rowInSections(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.COMMAND, for: indexPath) as! TeamLKTableViewCell
        
        switch indexPath.section {
        case 0:
            let model = tableModel.ownerTeams[indexPath.row]
            configureCell(cell: cell, model: model)
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
        case 1:
            let model = tableModel.playerTeams[indexPath.row]
            configureCell(cell: cell, model: model)
            cell.accessoryType = .none
        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if indexPath.section == 0 {
                showRemoveTeamAlert(teamName: tableModel.ownerTeams[indexPath.row].name!, delete: {
                    self.tableModel.ownerTeams.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    // TODO: do api request to delete team
                }) {
                    Print.m("cancel team delete")
                }
//                Print.m("delete cell at \(indexPath.row) -> \(tableModel.ownerTeams[indexPath.row])")
            }
            if indexPath.section == 1 {
                showRemoveTeamAlert(teamName: tableModel.playerTeams[indexPath.row].name!, delete: {
                    self.tableModel.playerTeams.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                }) {
                    Print.m("cancel team delete")
                }
                
//                Print.m("delete cell at \(indexPath.row) -> \(tableModel.fplayerTeams[indexPath.row])")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 { // logic: only owner of team can edit it
            return indexPath
        } else {
            return nil
        }
    }
}
