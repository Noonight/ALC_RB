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
    private enum Segues {
        static let edit = "segue_edit_active_match"
    }
    private enum StaticParams {
        static let emptyMessage = "Здесь будут отображаться текущие матчи"
    }
    
    private var viewModel: ScheduleRefViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var editSchedule: EditScheduleLKViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditScheduleLKViewController") as! EditScheduleLKViewController
        
        return viewController
    }()
    
    var tmpReferee: Players?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = nil
        self.tableView.es.addPullToRefresh {
            self.fetch()
            
        }
        
        emptyAction = {
            self.hideHUD()
            self.hud = nil
            self.fetch()
        }
        errorAction = {
            self.hideHUD()
            self.hud = nil
            self.fetch()
        }
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView()
        
        setEmptyMessage(message: StaticParams.emptyMessage)
        
        viewModel = ScheduleRefViewModel(dataManager: ApiRequests())
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetch()
    }
    
    func fetch() {
        self.viewModel.fetch() {
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func setupBindings() {
        viewModel.refreshing
            .subscribe { (event) in
                self.tableView.es.stopPullToRefresh()
                event.element! ? self.setState(state: .loading) : self.setState(state: .normal)
            }.disposed(by: disposeBag)
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
                self.setState(state: .error(message: event.element.debugDescription))
            }
            .disposed(by: disposeBag)
        
        viewModel.message
            .observeOn(MainScheduler.instance)
            .subscribe { message in
                self.showAlert(message: message.element!.message)
            }
            .disposed(by: disposeBag)
        
        viewModel.dataModel
            .subscribe { (dataModel) in
                self.tmpReferee = dataModel.element?.referees
                if dataModel.element?.activeMatches.matches.count ?? 0 < 1 {
                    self.setState(state: .empty)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.dataModel
            .map({ (dataModel) -> [ScheduleRefTableViewCell.CellModel] in
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
                        return referee.type == .firstReferee
//                        return referee.getRefereeType() == Referee.RefereeType.referee1
                    }).first
                    
                    var ref1: Person?
                    if referee1 != nil {
                        ref1 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee1!.person!.orEqual(person.id, { $0.id == person.id })
                        }).first
                    }
                    
                    let referee2 = element.referees.filter({ (referee) -> Bool in
                        return referee.type == .secondReferee
//                        return referee.getRefereeType() == Referee.RefereeType.referee2
                    }).first
                    var ref2: Person?
                    if referee2 != nil {
                        ref2 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee2!.person!.orEqual(person.id, { $0.id == person.id })
                        }).first
                    }
                    
                    let referee3 = element.referees.filter({ (referee) -> Bool in
                        return referee.type == .thirdReferee
//                        return referee.getRefereeType() == Referee.RefereeType.referee3
                    }).first
                    var ref3: Person?
                    if referee3 != nil {
                        ref3 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee3!.person!.orEqual(person.id, { $0.id == person.id })
                        }).first
                    }
                    
                    let timekeeper = element.referees.filter({ (referee) -> Bool in
                        return referee.type == .timekeeper
//                        return referee.getRefereeType() == Referee.RefereeType.timekeeper
                    }).first
                    var timekeep: Person?
                    if timekeeper != nil {
                        timekeep = dataModel.referees.people.filter({ (person) -> Bool in
                            return timekeeper!.person!.orEqual(person.id, { $0.id == person.id })
                        }).first
                    }
                    
                    let cell = ScheduleRefTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne, clubTeamTwo: teamTwo, referee1: ref1, referee2: ref2, referee3: ref3, timekeeper: timekeep)
                    cellModels.append(cell)
                    
                }
                return cellModels
            })
            .map({ cellModel -> [ScheduleRefTableViewCell.CellModel] in
                return cellModel.sorted(by: { (lModel, rModel) -> Bool in
//                    Print.m(lModel.activeMatch.date)
                    return lModel.activeMatch.date < rModel.activeMatch.date
//                    return lModel.activeMatch.date.getDateOfType(type: .utcTime) < rModel.activeMatch.date.getDateOfType(type: .utcTime)
                })
            })
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: ScheduleRefTableViewCell.self)) {  (row,cellModel,cell) in
                cell.configure(with: cellModel)
            }
            .disposed(by: disposeBag)
        
        
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                
                let cell = self.tableView.cellForRow(at: indexPath.element!) as? ScheduleRefTableViewCell
                if let cellModel = cell?.cellModel {
                    self.editSchedule.viewModel!.comingCellModel.value = cellModel
                    if let referees = self.tmpReferee {
                        self.editSchedule.viewModel?.comingReferees.value = referees
                        self.show(self.editSchedule, sender: self)
                    }
                } else {
                    self.showAlert(message: "Нету модели данных")
                }
                
                
                
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
