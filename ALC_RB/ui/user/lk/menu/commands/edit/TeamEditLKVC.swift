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
            .controlEvent([.editingChanged])
            .withLatestFrom(teamName_textField.rx.text)
            .throttle(2, scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe { text in
                guard let nameOptional = text.element  else { return }
                guard let name = nameOptional else { return }
                guard var team = self.viewModel.team.value else { return }
                team.name = name
                self.viewModel.team.accept(team)
            }.disposed(by: bag)
        
        viewModel.teamPersonInvitesViewModel.teamPersonInvites
            .observeOn(MainScheduler.instance)
            .map { $0.filter { $0.status == .pending } } // show only pending players
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
        
        teamPlayersInvitedTableView.tableFooterView = UIView()
        teamPlayersTableView.tableFooterView = UIView()
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TeamAddPlayersVC") as! TeamAddPlayersVC
        newViewController.viewModel.team.accept(self.viewModel.team.value)
        newViewController.viewModel.teamPersonInvitesViewModel = self.viewModel.teamPersonInvitesViewModel
        self.navigationController?.show(newViewController, sender: self)
    }
}

// MARK: Deleg. ( Edit / Delete )

extension TeamEditLKVC: TeamPlayerDeleteProtocol, TeamPlayerEditProtocol {
    func onDeleteBtnPressed(index: IndexPath, model: TeamPlayersStatus, success: @escaping () -> ()) {
        Print.m("delete pressed")
        
    }
    
    func onEditNumberComplete(model: TeamPlayersStatus) {
        Print.m("Edit number complete")
        guard var team = self.viewModel.team.value else { return }
        if team.players != nil {
            for i in 0..<team.players!.count {
                if team.players![i].id == model.id {
                    team.players![i] = model
                }
            }
        }
        self.viewModel.team.accept(team)
    }
    
    
}

extension TeamEditLKVC: TeamPlayerInvitedDeleteProtocol {
    func onDeleteInvBtnPressed(index: IndexPath, model: TeamPlayerInviteStatus, success: @escaping () -> ()) {
//        Print.m("delete in pressed")
        self.viewModel.teamPersonInvitesViewModel.requestCancelInvite(inviteId: model.id) { result in
            switch result {
            case .success(let teamPersonInvite):
//                dump(teamPersonInvite)
                var teamInvites = self.viewModel.teamPersonInvitesViewModel.teamPersonInvites.value
                for i in 0..<teamInvites.count {
                    if teamInvites[i].id == teamPersonInvite.id {
                        teamInvites[i] = teamPersonInvite
                    }
                }
                self.viewModel.teamPersonInvitesViewModel.teamPersonInvites.accept(teamInvites)
//                self.teamPlayersInvitedTableView.reloadRows(at: [index], with: .left)
//                self.teamPlayersInvitedTableView.
                success()
                self.teamPlayersInvitedTableView.reloadData()
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    
}
