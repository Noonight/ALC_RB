//
//  TeamProtocolTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditTeamProtocolVC: UIViewController {
    
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var trainerPhoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EditTeamProtocolViewModel = EditTeamProtocolViewModel(protocolApi: ProtocolApi(), teamApi: TeamApi())
    var table: EditTeamProtocolPlayersTable!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewBinds()
        
        
    }
    
}

// MARK: - SETUP

extension EditTeamProtocolVC {
    
    func setupTable() {
        table = EditTeamProtocolPlayersTable(tableActions: self)
        self.tableView.delegate = nil
        self.tableView.dataSource = table
    }
    
    func setupViewBinds() {
        
        viewModel
            .players
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                guard let players = element.element else { return }
                self.table.dataSource = players
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
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
    }
    
}

// MARK: - ACTIONS

extension EditTeamProtocolVC: EditTeamProtocolPlayersTableActions {
    
    func switchValueChanged(model: PlayerSwitchModelItem) {
        self.showAlert(message: "CALL BACK VALUE IS CHANGED = >> \(model.isRight)")
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        self.viewModel.requestEditMatchPlayers()
    }
}

// MARK: - HELPERS

extension EditTeamProtocolVC {
    
}

// MARK: - NAVIGATION

extension EditTeamProtocolVC {
    
}

// MARK: - REACTIVE

extension Reactive where Base: EditTeamProtocolVC {
    
    internal var loading: Binder<Bool> {
        return Binder(self.base) { vc, isLoading in
            if isLoading == true {
                if vc.hud != nil {
                    vc.hud?.setToLoadingView(message: "Сохраняем...")
                } else {
                    vc.hud = vc.showLoadingViewHUD(with: "Сохраняем...")
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
}
