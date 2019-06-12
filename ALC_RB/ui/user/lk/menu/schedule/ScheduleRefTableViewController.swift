//
//  ScheduleTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ScheduleRefTableViewController: BaseStateTableViewController {
    private enum CellIdentifiers {
        static let cell = "activeMatches_cell"
    }
    private enum StaticParams {
        static let emptyMessage = ""
    }
    
    private var viewModel: ScheduleRefViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView()
        
        setEmptyMessage(message: StaticParams.emptyMessage)
        
        viewModel = ScheduleRefViewModel(dataManager: ApiRequests())
        
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
        
//        viewModel.activeMatches
//            .subscribe { (activeMatches) in
//                if activeMatches.element?.count == 0 {
//                    self.setState(state: .empty)
//                }
//            }
//            .disposed(by: disposeBag)
        
//        viewModel.activeMatches
//            .map { (activeMatches) -> [ActiveMatch] in
//                return activeMatches.matches
//            }
//            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: RefereeLKTableViewCell.self)) {  (row,activeMatch,cell) in
//                cell.configure(with: activeMatch)
//            }
//            .disposed(by: disposeBag)
        
        viewModel.dataModel
            .subscribe { (dataModel) in
                if dataModel.element?.activeMatches.matches.count == 0 {
                    self.setState(state: .empty)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.dataModel
            .flatMap({ (dataModel) -> PublishSubject<[ScheduleRefTableViewCell.CellModel]> in
                
                var subject: PublishSubject<[ScheduleRefTableViewCell.CellModel]> = PublishSubject()
                var cellModels: [ScheduleRefTableViewCell.CellModel] = []
                
                let activeMatches = dataModel.activeMatches
                for element in activeMatches.matches {
                    
                    let teamOne = dataModel.clubs.filter({ (soloClub) -> Bool in
                        if element.teamOne.club == soloClub.club.id {
                            return true
                        }
                        return false
                    }).first?.club ?? nil
                    let teamTwo = dataModel.clubs.filter({ (soloClub) -> Bool in
                        if element.teamTwo.club == soloClub.club.id {
                            return true
                        }
                        return false
                    }).first?.club ?? nil
                    
                    let referee1 = element.referees.filter({ (referee) -> Bool in
                        return referee.getRefereeType() == Referee.RefereeType.referee1
                    }).first
                    
                    var ref1: Person?
                    if referee1 != nil {
                        ref1 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee1?.person == person.id
                        }).first
                    }
                    
//                    let referee1 = dataModel.referees.people.filter({ (person) -> Bool in
//                        if person.id == element.referees
//                    })
                    
                    let cell = ScheduleRefTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne!, clubTeamTwo: teamTwo!, referee1: ref1, referee2: nil, referee3: nil, timekeeper: nil)
                    cellModels.append(cell)
                    
                }
                
                subject.onNext(cellModels)
                
                return subject
            })
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: ScheduleRefTableViewCell.self)) {  (row,cellModel,cell) in
//                cell.configure(with: activeMatch)
                cell.configure(with: cellModel)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
