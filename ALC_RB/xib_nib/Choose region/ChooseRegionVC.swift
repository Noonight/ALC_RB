//
//  ChooseRegionVC.swift
//  ALC_RB
//
//  Created by mac on 05.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChooseRegionResult {
    func complete(region: RegionMy)
}

final class ChooseRegionVC: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var callBack: ChooseRegionResult?
    private var viewModel: ChooseRegionVM!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        setupBinds()
        
    }

}

// MARK: - SETUP

extension ChooseRegionVC {
    
    func setupTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    func setupViewModel() {
        self.viewModel = ChooseRegionVM(dataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        self.searchTF.rx
            .text
            .orEmpty
            .throttle(Constants.Values.defaultSearchThrottle, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe({ text in
                guard let mText = text.element else { return }
                self.viewModel.query.accept(mText)
                self.viewModel.fetch()
            })
            .disposed(by: bag)
        
        // TODO: if text field is empty show all regions
        
        // TODO: if text field is not empty show cancel button
        
        self.viewModel
            .findedRegions
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(cellIdentifier: ChooseRegionCell.ID, cellType: ChooseRegionCell.self)) { row, region, cell in
                cell.region = region
            }
            .disposed(by: bag)
        
        
        
        self.viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.tableView.rx.loading)
            .disposed(by: bag)
        
        self.viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.tableView.rx.error)
            .disposed(by: bag)
        
        self.viewModel
            .message
            .asDriver(onErrorJustReturn: SingleLineMessage(message: "Driver error"))
            .drive(self.rx.message)
            .disposed(by: bag)
    }
    
}
