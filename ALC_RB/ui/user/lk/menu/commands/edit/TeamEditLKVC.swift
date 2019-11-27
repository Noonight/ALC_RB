//
//  CommandEditLKViewController.swift
//  ALC_RB
//
//  Created by ayur on 03.04.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TeamEditLKVC: UIViewController {
    
    @IBOutlet weak var teamName_textField: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var teamPlayersTableView: IntrinsicTableView!
    @IBOutlet weak var teamPlayersInvitedTableView: IntrinsicTableView!
    
    var viewModel: TeamEditLKViewModel!
    private let bag = DisposeBag()
    
    let teamPlayersInTable = TeamPlayersInTable()
    let teamPlayersInvitedTable = TeamPlayersInvitedTable()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableViews()
        setupView()
        setupBinds()
        
        viewModel.fetch()
    }
    
}

// MARK: - SETUP

extension TeamEditLKVC {
    
    func setupBinds() {
        
        teamName_textField.rx
            .controlEvent([.editingDidEnd])
            .observeOn(MainScheduler.instance)
            .subscribe {
                guard let newName = self.teamName_textField.text else { return }
                guard var team = self.viewModel.team.value else { return }
                team.name = newName
                self.viewModel.team.accept(team)
            }.disposed(by: bag)
        
//        viewModel.team
        viewModel.teamPersonInvitesViewModel.teamPersonInvites
            .observeOn(MainScheduler.instance)
            .subscribe { invitesEvent in
                guard let teamInvites = invitesEvent.element else { return }
                self.teamPlayersInvitedTable.dataSource = teamInvites
                self.teamPlayersInvitedTableView.reloadData()
            }.disposed(by: bag)
        
        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel.message
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.message)
            .disposed(by: bag)
        
        viewModel.error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
    }
    
    func setupTableViews() {
        teamPlayersTableView.dataSource = teamPlayersInTable
        teamPlayersTableView.delegate = teamPlayersInTable
        
        teamPlayersInTable.deleteBtnProtocol = self
        teamPlayersInTable.editNumberCompleteProtocol = self
        
        teamPlayersInvitedTableView.dataSource = teamPlayersInvitedTable
        teamPlayersInvitedTableView.delegate = teamPlayersInvitedTable
        
        teamPlayersInvitedTable.deleteBtnProtocol = self
        
//        teamPlayersInvitedTableView.tableFooterView = UIView()
//        teamPlayersTableView.tableFooterView = UIView()
    }
    
    
    
    func setupView() {
        self.teamName_textField.text = self.viewModel.team.value?.name
        
        self.teamPlayersInTable.dataSource = self.viewModel.team.value?.players ?? []
        self.teamPlayersTableView.reloadData()
    }
    
}

// MARK: - ACTIONS

extension TeamEditLKVC {
    
    @IBAction func onAddPlayerBtnPressed(_ sender: UIButton) {
        showAddPlayers()
    }
    
    @IBAction func onNavBarSaveBtnPressed(_ sender: UIBarButtonItem) {
        self.viewModel.requestPatchTeam {
            self.showSuccessViewHUD(seconds: 2) {
                Print.m("success end showing")
            }
        }
    }
}

// MARK: - NAVIGATION

extension TeamEditLKVC {
    
    func showAddPlayers() {
//        CommandAddPlayerTableViewController
    }
}

// MARK: Deleg. ( Edit / Delete )

extension TeamEditLKVC: TeamPlayerDeleteProtocol, TeamPlayerEditProtocol {
    func onDeleteBtnPressed(index: IndexPath, model: TeamPlayersStatus, success: @escaping () -> ()) {
        Print.m("delete pressed")
    }
    
    func onEditNumberComplete(model: TeamPlayersStatus) {
        Print.m("Edit number complete")
    }
    
    
}

extension TeamEditLKVC: TeamPlayerInvitedDeleteProtocol {
    func onDeleteInvBtnPressed(index: IndexPath, model: TeamPlayerInviteStatus, success: @escaping () -> ()) {
        Print.m("delete in pressed")
    }
    
    
}
