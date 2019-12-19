//
//  WorkProtocolVC.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WorkProtocolEventsVC: UIViewController {

    static func getInstance(match: Match) -> WorkProtocolEventsVC {
        let vc = WorkProtocolEventsVC()
        
        vc.viewModel.match = match
        
        return vc
    }
    
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var table: WorkProtocolEventsTable!
    private let bag = DisposeBag()
    var viewModel = WorkProtocolEventsViewModel(protocolApi: ProtocolApi())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
    }

}

// MARK: SETUP

extension WorkProtocolEventsVC {
    
    func setupTable() {
        table = WorkProtocolEventsTable(tableActions: self)
        tableView.delegate = table
        tableView.dataSource = table
        tableView.register(UINib(nibName: "WorkProtocolEventsCell", bundle: Bundle.main), forCellReuseIdentifier: WorkProtocolEventsCell.ID)
    }
    
    func setupViewBinds() {
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .error
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .message
            .observeOn(MainScheduler.instance)
            .bind(to: self.rx.message)
            .disposed(by: bag)
    }
}

// MARK: ACTIONS

extension WorkProtocolEventsVC: TableActions {
    
    func onCellSelected(model: CellModel) {
        if model is WorkProtocolEventModelItem {
            var model = model as! WorkProtocolEventModelItem
            self.showAlert(message: model.creatorName ?? "ЭЭ")
        }
    }
    
}
