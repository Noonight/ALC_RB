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
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView()
        
        setEmptyMessage(message: StaticParams.emptyMessage)
        
        viewModel = ScheduleRefViewModel(dataManager: ApiRequests())
        
        setupBindings()
        
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
                self.tmpReferee = dataModel.element?.referees
                if dataModel.element?.activeMatches.matches.count ?? 0 < 1 {
                    self.setState(state: .empty)
                }
            }
            .disposed(by: disposeBag)
        
        //        viewModel.dataModel.subscribe { (event) in
        //            Print.m(event.element)
        //            }.disposed(by: disposeBag)
        
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
                        return referee.getRefereeType() == Referee.RefereeType.referee1
                    }).first
                    
                    var ref1: Person?
                    if referee1 != nil {
                        ref1 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee1?.person == person.id
                        }).first
                    }
                    
                    let referee2 = element.referees.filter({ (referee) -> Bool in
                        return referee.getRefereeType() == Referee.RefereeType.referee2
                    }).first
                    var ref2: Person?
                    if referee2 != nil {
                        ref2 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee2?.person == person.id
                        }).first
                    }
                    
                    let referee3 = element.referees.filter({ (referee) -> Bool in
                        return referee.getRefereeType() == Referee.RefereeType.referee3
                    }).first
                    var ref3: Person?
                    if referee3 != nil {
                        ref3 = dataModel.referees.people.filter({ (person) -> Bool in
                            return referee3?.person == person.id
                        }).first
                    }
                    
                    let timekeeper = element.referees.filter({ (referee) -> Bool in
                        return referee.getRefereeType() == Referee.RefereeType.timekeeper
                    }).first
                    var timekeep: Person?
                    if timekeeper != nil {
                        timekeep = dataModel.referees.people.filter({ (person) -> Bool in
                            return timekeeper?.person == person.id
                        }).first
                    }
                    
                    let cell = ScheduleRefTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne!, clubTeamTwo: teamTwo!, referee1: ref1, referee2: ref2, referee3: ref3, timekeeper: timekeep)
                    cellModels.append(cell)
                    
                    //                    dump(cellModels)
                    
                }
                return cellModels
            })
            .map({ cellModel -> [ScheduleRefTableViewCell.CellModel] in
                return cellModel.sorted(by: { (lModel, rModel) -> Bool in
                    Print.m(lModel.activeMatch.date)
                    return lModel.activeMatch.date.getDateOfType(type: .utcTime) < rModel.activeMatch.date.getDateOfType(type: .utcTime)
                })
            })
            //            .flatMap({ (dataModel) -> PublishSubject<[ScheduleRefTableViewCell.CellModel]> in
            //
            //                let subject: PublishSubject<[ScheduleRefTableViewCell.CellModel]> = PublishSubject()
            //                var cellModels: [ScheduleRefTableViewCell.CellModel] = []
            //
            //                let activeMatches = dataModel.activeMatches
            //                for element in activeMatches.matches {
            //
            //                    let teamOne = dataModel.clubs.filter({ (soloClub) -> Bool in
            //                        if element.teamOne.club == soloClub.club.id {
            //                            return true
            //                        }
            //                        return false
            //                    }).first?.club ?? nil
            //                    let teamTwo = dataModel.clubs.filter({ (soloClub) -> Bool in
            //                        if element.teamTwo.club == soloClub.club.id {
            //                            return true
            //                        }
            //                        return false
            //                    }).first?.club ?? nil
            //
            //                    let referee1 = element.referees.filter({ (referee) -> Bool in
            //                        return referee.getRefereeType() == Referee.RefereeType.referee1
            //                    }).first
            //
            //                    var ref1: Person?
            //                    if referee1 != nil {
            //                        ref1 = dataModel.referees.people.filter({ (person) -> Bool in
            //                            return referee1?.person == person.id
            //                        }).first
            //                    }
            //
            ////                    let referee1 = dataModel.referees.people.filter({ (person) -> Bool in
            ////                        if person.id == element.referees
            ////                    })
            //
            //                    let cell = ScheduleRefTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne!, clubTeamTwo: teamTwo!, referee1: ref1, referee2: nil, referee3: nil, timekeeper: nil)
            //                    cellModels.append(cell)
            //
            //                    dump(cellModels)
            //
            //                }
            //
            //                subject.onNext(cellModels)
            //
            //                dump(subject)
            //
            //                return subject
            //            })
            .bind(to: tableView.rx.items(cellIdentifier: CellIdentifiers.cell, cellType: ScheduleRefTableViewCell.self)) {  (row,cellModel,cell) in
                //                cell.configure(with: activeMatch)
                cell.configure(with: cellModel)
            }
            .disposed(by: disposeBag)
        
        
        
        tableView.rx.itemSelected
            .subscribe { (indexPath) in
                
                let cell = self.tableView.cellForRow(at: indexPath.element!) as? ScheduleRefTableViewCell
//                self.editSchedule.viewModel.comingModel.value(cell!.cellModel!)
                if let cellModel = cell?.cellModel {
                    self.editSchedule.viewModel!.comingCellModel.value = cellModel
                    if let referees = self.tmpReferee {
                        self.editSchedule.viewModel?.comingReferees.value = referees
                        self.show(self.editSchedule, sender: self)
                    }
//                    self.viewModel.dataModel
//                        .subscribe({ dataModel in
//                            self.editSchedule.viewModel?.comingReferees.value = dataModel.element!.referees
//                        })
//                        .disposed(by: self.disposeBag)
                } else {
                    self.showAlert(message: "Нету модели данных")
                }
//                self.editSchedule.viewModel.activeMatch.onNext(cell!.cellModel!.activeMatch)
//                self.editSchedule.viewModel.activeMatch.onNext(cell?.cellModel?.activeMatch)
//                self.editSchedule.viewModel.referees.onNext(cell?.cellModel.)
                
                
                
                self.tableView.deselectRow(at: indexPath.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.edit,
            let destination = segue.destination as? EditScheduleLKViewController,
            let cellId = tableView.indexPathForSelectedRow
        {
            self.viewModel.dataModel
                .map { (dataModel) -> ActiveMatch in
                    return dataModel.activeMatches.matches[cellId.row]
                }
                .takeLast(1)
                .subscribe { (activeMatchEvent) in
                    Print.m(activeMatchEvent.element!)
                    destination.viewModel.activeMatch.onNext(activeMatchEvent.element!)
                }
                .disposed(by: self.disposeBag)
            
            self.viewModel.dataModel
                .map { (dataModel) -> Players in
                    return dataModel.referees
                }
                .subscribe { (referees) in
                    destination.viewModel.referees.onNext(referees.element!)
                }
                .disposed(by: self.disposeBag)
        }
    }*/
    
}
