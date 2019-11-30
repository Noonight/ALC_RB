//
//  InvitationLKTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ESPullToRefresh

class InvitationLKTVC: UITableViewController {
    
    var refreshUserCallBack: RefreshUserProtocol?
    
    private let bag = DisposeBag()
    private var viewModel: InvitationViewModel!
    private var invitationTable: InvitationLKTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewModel()
        setupBinds()
        
        self.viewModel.fetch()
    }
    
}

// MARK: - SETUP

extension InvitationLKTVC {
    
    func setupBinds() {
        
        viewModel
            .invites
            .observeOn(MainScheduler.instance)
            .subscribe { elements in
                guard let invites = elements.element else { return }
                self.invitationTable.dataSource = invites
                self.tableView.reloadData()
            }.disposed(by: bag)
        
        viewModel
            .invites
//            .observeOn(MainScheduler.instance)
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.empty)
            .disposed(by: bag)
        
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
    
    func setupViewModel() {
        self.viewModel = InvitationViewModel(inviteApi: InviteApi(), teamApi: TeamApi())
    }
    
    func setupTable() {
        self.invitationTable = InvitationLKTable(tableActions: self)
        self.tableView.delegate = invitationTable
        self.tableView.dataSource = invitationTable
    }
    
}

// MARK: - ACTIONS

extension InvitationLKTVC: InvitationTableActions {
    func onOkPressed(model: InvitationModelItem, closure: @escaping () -> ()) {
        self.viewModel.requestAcceptInvite(inviteId: model.inviteStatus.id) { result in
            switch result {
            case .success(let invite):
                var invites = self.viewModel.invites.value
                invites.removeAll(where: { mInvite -> Bool in
                    return mInvite.inviteStatus.id == invite.id
                })
                self.viewModel.invites.accept(invites)
                closure()
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func onCancelPressed(model: InvitationModelItem, closure: @escaping () -> ()) {
        self.viewModel.requestRejectInvite(inviteId: model.inviteStatus.id) { result in
            switch result {
            case .success(let invite):
                var invites = self.viewModel.invites.value
                invites.removeAll(where: { mInvite -> Bool in
                    return mInvite.inviteStatus.id == invite.id
                })
                self.viewModel.invites.accept(invites)
                closure()
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
