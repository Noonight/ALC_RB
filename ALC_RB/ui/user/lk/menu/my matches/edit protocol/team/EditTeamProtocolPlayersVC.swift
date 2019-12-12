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

protocol EditTeamPlayersCallBack {
    func back(match: Match)
}

class EditTeamProtocolPlayersVC: UIViewController {
    
    static func getInstance() -> EditTeamProtocolPlayersVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let editTeamPlayersVC = storyboard.instantiateViewController(withIdentifier: "EditTeamProtocolVC") as! EditTeamProtocolPlayersVC
        
        return editTeamPlayersVC
    }
    
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var trainerPhoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var back: EditTeamPlayersCallBack?
    var viewModel: EditTeamProtocolViewModel = EditTeamProtocolViewModel(matchApi: MatchApi())
    var table: EditTeamProtocolPlayersTable!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupViewBinds()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.setupDataModel()
        self.setupView()
    }
    
}

// MARK: - SETUP

extension EditTeamProtocolPlayersVC {
    
    func setupView() {
        guard let team = self.viewModel.team.value else { return }
        self.title = team.name
        self.trainerNameLabel.text = team.trainer?.getValue()?.getFullName()
        self.trainerPhoneLabel.text = team.creatorPhone
    }
    
    func setupTable() {
        table = EditTeamProtocolPlayersTable(tableActions: self)
        self.tableView.delegate = nil
        self.tableView.dataSource = table
    }
    
    func setupViewBinds() {
        
        viewModel
            .changedMatch
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                guard let match = element.element else { return }
                self.showSuccessViewHUD(message: "Сохранение успешно", seconds: 2, closure: {
                    self.back?.back(match: match)
                })
            }.disposed(by: bag)
        
        viewModel
            .playersChanged
            .observeOn(MainScheduler.instance)
            .subscribe { element in
                let players = self.viewModel.players.value
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
        
        viewModel
            .noTeamPlayers
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.empty)
            .disposed(by: bag)
    }
    
}

// MARK: - ACTIONS

extension EditTeamProtocolPlayersVC: EditTeamProtocolPlayersTableActions {
    
    func switchValueChanged(model: PlayerSwitchModelItem) {
        var players = self.viewModel.players.value
        for i in 0..<players.count {
            if players[i].player.player.id == model.player.player.id {
                players[i] = model
            }
        }
    }
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        self.viewModel.requestEditMatchPlayers()
    }
}

// MARK: - HELPERS

extension EditTeamProtocolPlayersVC {
    
}

// MARK: - NAVIGATION

extension EditTeamProtocolPlayersVC {
    
}

// MARK: - REACTIVE

extension Reactive where Base: EditTeamProtocolPlayersVC {
    
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
    
    internal var empty: Binder<Bool> {
        return Binder(self.base) { vc, isEmpty in
            if isEmpty == true {
                vc.tableView.separatorStyle = .none
                if vc.hud != nil {
                    vc.hud?.hide(animated: true)
                    vc.hud = vc.showEmptyViewHUD(addTo: vc.tableView, message: "В команде нет игроков", tap: {
                        Print.m("tap on empty")
                    })
                } else {
                    vc.hud = vc.showEmptyViewHUD(addTo: vc.tableView, message: "В команде нет игроков", tap: {
                        Print.m("tap on empty")
                    })
                }
            } else {
                vc.tableView.separatorStyle = .singleLine
                vc.hud?.hide(animated: true)
                vc.hud = nil
            }
        }
    }
    
}
