//
//  RefereesLKTableViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RefereesLKTableViewController: BaseStateTableViewController {
    private enum CellIdentifiers {
        static let cell = "referee_cell"
    }
    
    private var viewModel: RefereesViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView()
        
        viewModel = RefereesViewModel(dataManager: ApiRequests())
        
        setupBindings()
        
        viewModel.fetch()
    }
    
    func setupBindings() {
        viewModel.refreshing
            .subscribe { (event) in
                event.element! ? self.setState(state: .loading) : self.setState(state: .normal)
                
//                self.setState(state: .loading)
            }.disposed(by: disposeBag)
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
//                Print.m(event.element)
                self.setState(state: .error(message: event.element.debugDescription))
            }.disposed(by: disposeBag)
        
        viewModel.referees
            .map { (players) -> [Person] in
                return players.people
            }
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: RefereeLKTableViewCell.self)) {  (row,referee,cell) in
                cell.configure(with: referee)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
