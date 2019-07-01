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
    private enum Segues {
        static let segue = "segue_ref_matches"
    }
    private enum StaticParams {
        static let emptyMessage = "Здесь будут отображаться судьи"
    }
    
    private var viewModel: RefereesViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView()
        
        setEmptyMessage(message: StaticParams.emptyMessage)
        
        viewModel = RefereesViewModel(dataManager: ApiRequests())
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetch()
    }
    
    func setupBindings() {
        viewModel.refreshing
            .subscribe { (event) in
                event.element! ? self.setState(state: .loading) : self.setState(state: .normal)
            }.disposed(by: disposeBag)
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
                self.setState(state: .error(message: event.element.debugDescription))
            }
            .disposed(by: disposeBag)
        
        viewModel.referees
            .subscribe { (players) in
                if players.element?.people.count == 0 {
                    self.setState(state: .empty)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.referees
            .map { (players) -> [Person] in
                return players.people
            }
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: RefereeLKTableViewCell.self)) {  (row,referee,cell) in
//                Print.m(referee)
                cell.configure(with: referee)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.segue,
            let destination = segue.destination as? RefereeEditMatchesLKTableViewController,
            let cellIndex = tableView.indexPathForSelectedRow
        {
            let cell = tableView.cellForRow(at: cellIndex) as! RefereeLKTableViewCell
            destination.comingPerson = cell.model!
        }
    }
}
