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
    
    private var viewModel: ScheduleTableViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBinds()
    }
}

// MARK: - SETUP

extension ScheduleTableViewController {
    
    func setupViewModel() {
        self.viewModel = ScheduleTableViewModel(dataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        viewModel
            .items
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleTableViewCell.ID, cellType: ScheduleTableViewCell.self)) { (index, schedule, cell) in
                // do smth
        }.disposed(by: disposeBag)
    }
    
}

// MARK: - NAVIGATION

extension ScheduleTableViewController {
    
    func showProtocol() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MatchProtocolViewController") as! MatchProtocolViewController
        
        self.navigationController?.show(viewController, sender: self)
    }
    
}
