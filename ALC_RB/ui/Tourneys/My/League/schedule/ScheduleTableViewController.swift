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
    
    var viewModel = ScheduleTableViewModel(matchApi: MatchApi())
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
            .items
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: ScheduleTableViewCell.ID, cellType: ScheduleTableViewCell.self)) { (index, match, cell) in
                cell.matchScheduleModelItem = match
        }
        .disposed(by: disposeBag)
        
        viewModel
            .items
            .map({ $0.count == 0 })
            .bind(to: self.rx.empty)
            .disposed(by: disposeBag)
        
//        viewModel
//            .leagueDetailModel
//            .map({ leagueDM -> [Match] in
//                let matches = leagueDM.league.matches ?? []
//                return matches
//            })
//            .map({ matches in
//                matches.map({ match in
//                    return MatchScheduleModelItem(
//                        match: match
//                    )
//                })
//            })
//            .map({ matches -> [MatchScheduleModelItem] in
//                let mMatches = matches.filter { match -> Bool in
//                    return match.teamOne != nil && match.teamTwo != nil
//                }
//                return mMatches
//            })
            //            .map({ matches -> [MatchScheduleModelItem] in
            //                var mMatches = matches
            //                mMatches.sort { left, right -> Bool in
            //                    return left.match.date?.date < right.match.date?.date
            //                }
            //                return mMatches
            //            })
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(cellIdentifier: ScheduleTableViewCell.ID, cellType: ScheduleTableViewCell.self)) { (index, match, cell) in
//                cell.matchScheduleModelItem = match
//                if cell.matchScheduleModelItem.teamOne == nil || cell.matchScheduleModelItem.teamTwo == nil || cell.matchScheduleModelItem.match.events?.count ?? 0 == 0 {
//                    cell.accessoryType = .none
//                } else {
//                    cell.accessoryType = .disclosureIndicator
//                }
//        }
//        .disposed(by: disposeBag)
        
//        viewModel
//            .leagueDetailModel
//            .map({ $0.league.matches ?? [] })
//            .map({ $0.count == 0 })
//            .bind(to: self.rx.empty)
//            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe({ indexPath in
                let cell = self.tableView.cellForRow(at: indexPath.element!) as! ScheduleTableViewCell
                if cell.accessoryType == .disclosureIndicator {
                    self.showProtocol(match: cell.matchScheduleModelItem.match)
                }
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
    
    func showProtocol(match: Match) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MatchProtocolViewController") as! MatchProtocolViewController
        
        viewController.viewModel = ProtocolAllViewModel(match: match, leagueDetailModel: self.viewModel.leagueDetailModel.value!)
        
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
