//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 13.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ScheduleTableViewController: UITableViewController {
    
    static func getInstance() -> ScheduleTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
        return viewController
    }
    
//    var _leagueDetailModel = LeagueDetailModel()
//    var leagueDetailModel: LeagueDetailModel
//    {
//        get {
//            return _leagueDetailModel
//        }
//        set {
//            if newValue.leagueInfo.league.matches?.count != 0
//            {
//                var newVal = newValue
//                let hud = self.tableView.showLoadingViewHUD(with: "Сортируем...")
//                if let curMatches = newVal.leagueInfo.league.matches {
//
//                    let sortedMatches = SortMatchesByDateHelper.sort(type: .lowToHigh, matches: curMatches) // sorting matches by date
//                    newVal.leagueInfo.league.matches = sortedMatches
//                }
//                _leagueDetailModel = newVal
//                hud.hide(animated: false)
//                hud.showSuccessAfterAndHideAfter(withMessage: "Готово")
//                self.updateUI()
//            }
//            else
//            {
//                self.updateUI()
//            }
//        }
//    }
    
    var viewModel = ScheduleTableViewModel(dataManager: ApiRequests())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinds()
        
        viewModel.fetch()
    }
}

// MARK: - SETUP

extension ScheduleTableViewController {
    
    func setupBinds() {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
//        viewModel
//            .items
//            .observeOn(MainScheduler.instance)
//            .bind(to: tableView.rx.items(cellIdentifier: ScheduleTableViewCell.ID, cellType: ScheduleTableViewCell.self)) { (index, match, cell) in
//                cell.matchScheduleModelItem = match
//            }
//            .disposed(by: disposeBag)
        
        viewModel
            .leagueDetailModel
            .map({ $0.leagueInfo.league.matches ?? [] })
            .map({ $0.map({ match in
                return MatchScheduleModelItem(
                match: match,
                teamOne: self.viewModel.leagueDetailModel.value.leagueInfo.league.teams?.filter({ team in
                    return team.id == match.teamOne
                    }).first,
                teamTwo: self.viewModel.leagueDetailModel.value.leagueInfo.league.teams?.filter({ team in
                    return team.id == match.teamTwo
                    }).first  )
            })
            })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: ScheduleTableViewCell.ID, cellType: ScheduleTableViewCell.self)) { (index, match, cell) in
                cell.matchScheduleModelItem = match
            }
        .disposed(by: disposeBag)
        
        viewModel
            .leagueDetailModel
            .map({ $0.leagueInfo.league.matches ?? [] })
            .map({ $0.count == 0 })
            .bind(to: self.rx.empty)
            .disposed(by: disposeBag)
        
//        viewModel
//            .items
//            .map({ $0.count == 0})
//            .bind(to: self.rx.empty)
//            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe({ indexPath in
                let cell = self.tableView.cellForRow(at: indexPath.element!) as! ScheduleTableViewCell
                
                self.showProtocol(match: cell.matchScheduleModelItem.match)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.isLoading)
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.error)
            .disposed(by: disposeBag)
        
        viewModel
            .mMessage
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - NAVIGATION

extension ScheduleTableViewController {
    
    func showProtocol(match: LIMatch) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MatchProtocolViewController") as! MatchProtocolViewController
        
        viewController.viewModel = ProtocolAllViewModel(match: match, leagueDetailModel: self.viewModel.leagueDetailModel.value)
        
        self.navigationController?.show(viewController, sender: self)
    }
    
}

// MARK: REACTIVE

extension Reactive where Base: ScheduleTableViewController {
    
    internal var isLoading: Binder<Bool> {
        return Binder(self.base) { vc, loading in
            if loading == true {
                if vc.hud != nil {
                    vc.hud?.setToLoadingView()
                } else {
                    vc.hud = vc.showLoadingViewHUD()
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
    internal var error: Binder<Error?> {
        return Binder(self.base) { vc, error in
            guard let mError = error else { return }
            if vc.hud != nil {
                vc.hud?.setToFailureView(detailMessage: mError.localizedDescription, tap: {
//                    vc.viewModel.fetch()
                })
            } else {
                vc.hud = vc.showFailureViewHUD(detailMessage: mError.localizedDescription, tap: {
//                    vc.viewModel.fetch()
                })
            }
        }
    }
    
    internal var message: Binder<SingleLineMessage?> {
        return Binder(self.base) { vc, message in
            guard let mMessage = message else { return }
            if vc.hud != nil {
                vc.hud?.setToFailureView(detailMessage: mMessage.message, tap: {
//                    vc.viewModel.fetch()
                })
            } else {
                vc.hud = vc.showFailureViewHUD(detailMessage: mMessage.message, tap: {
//                    vc.viewModel.fetch()
                })
            }
        }
    }
    
    internal var empty: Binder<Bool> {
        return Binder(self.base) { vc, isEmpty in
            if isEmpty == true {
                if vc.hud != nil {
                    vc.hud?.setToEmptyView(message: "", detailMessage: "Матчей нет", tap: {
                        vc.viewModel.fetch()
                    })
                } else {
                    vc.hud = vc.showEmptyViewHUD(message: "", detailMessage: "Матчей нет", tap: {
                        vc.viewModel.fetch()
                    })
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
}
