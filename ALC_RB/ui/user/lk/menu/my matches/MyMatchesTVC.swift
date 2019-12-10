//
//  MyMatchesRefTableViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MyMatchesTVC: UITableViewController {
    
    private lazy var workProtocol: EditMatchProtocolViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditMatchProtocolViewControllerProtocol") as! EditMatchProtocolViewController
        
        return viewController
    }()
    
    var viewModel: MyMatchesViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTable()
        setupViewBinds()
        setupPullToRefresh()
        
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // issue: cell not worked when we go back
        self.title = "Матчи"
        navigationController?.navigationBar.topItem?.title = self.title
    }
}

// MARK: - SETUP

extension MyMatchesTVC {
    
    func setupViewModel() {
        viewModel = MyMatchesViewModel(matchApi: MatchApi())
    }
    
    func setupTable() {
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func setupViewBinds() {
        
        viewModel
            .matches
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(cellIdentifier: MyMatchesRefTableViewCell.ID, cellType: MyMatchesRefTableViewCell.self)) { row, model, cell in
                cell.myMatchModel = model
                if self.userIsThirdReferee(match: model.match) {
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.accessoryType = .none
                }
            }.disposed(by: bag)
        
        self.tableView.rx
            .modelSelected(MyMatchModelItem.self)
            .subscribe { element in
                guard let model = element.element else { return }
                if self.userIsThirdReferee(match: model.match) {
                    self.showWorkProtocol(match: model.match)
                } else {
                    self.showPublicProtocol(match: model.match)
                }
            }.disposed(by: bag)
        
        tableView.rx
            .itemSelected
            .subscribe { element in
                guard let index = element.element else { return }
                self.tableView.deselectRow(at: index, animated: true)
            }.disposed(by: bag)
        
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
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
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

// MARK: - HELPER

extension MyMatchesTVC {
    
    func userIsThirdReferee(match: Match) -> Bool {
        guard let userId = UserDefaultsHelper().getAuthorizedUser()?.person.id else { return false }
        if match.referees?.filter({ referee -> Bool in
            return referee.person?.getId() ?? referee.person?.getValue()?.id == userId && referee.type == .thirdReferee
        }).first != nil {
            return true
        }
        return false
    }
    
}

// MARK: - NAVIGATION

extension MyMatchesTVC {
    
    func showWorkProtocol(match: Match) {
//        self.showAlert(message: "SHOW WORK PROTOCOL")
//        workProtocol.leagueDetailModel = LeagueDetailModel(tourney: Tourney(), league: (match.league?.getValue())!)
//        workProtocol.match = match
        workProtocol.presenter.match = match
        self.show(workProtocol, sender: self)
    }
    
    func showPublicProtocol(match: Match) {
        self.showAlert(message: "SHOW PUBLIC PROTOCOL")
    }
    
}
