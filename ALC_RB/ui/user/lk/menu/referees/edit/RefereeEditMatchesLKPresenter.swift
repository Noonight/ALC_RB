//
//  RefereeEditMatchesLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 30.06.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol RefereeEditMatchesView: MvpView {
    func onFetchModelSuccess(dataModel: [RefereeEditMatchesLKTableViewCell.CellModel])
    func onFetchModelMessage(message: SingleLineMessage)
    func onFetchModelFailure(error: Error)
    
    func onResponseEditMatchSuccess(soloMatch: Match)
    func onResponseEditMatchMessage(message: SingleLineMessage)
    func onResponseEditMatchFailure(error: Error)
}

class RefereeEditMatchesLKPresenter: MvpPresenter<RefereeEditMatchesLKTableViewController> {
    let dataManager = ApiRequests()
    
    var cache: EditMatchReferees?
    
    func requestEditMatchReferee(token: String, editMatchReferees: EditMatchReferees) {
        self.cache = editMatchReferees
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees) { result in
            switch result {
            case .success(let match):
                self.getView().onResponseEditMatchSuccess(soloMatch: match)
            case .message(let message):
                self.getView().onResponseEditMatchMessage(message: message)
            case .failure(let error):
                self.getView().onResponseEditMatchFailure(error: error)
            }
        }
    }
    
    func fetch(refId: String) {
        Print.m("fetching")
        self.getView().setState(state: .loading)
        
        dataManager.get_scheduleRefereeData { result in
            switch result {
            case .success(let tuple):
                var cellModels: [RefereeEditMatchesLKTableViewCell.CellModel] = []
                let allTableModel = self.prepareTableData(activeMatches: tuple.0, referees: tuple.1, clubs: tuple.2)
                let refInside = allTableModel.filter({ cellModel -> Bool in
                    return cellModel.activeMatch.referees.contains(where: { referee -> Bool in
                        switch referee.person!.value {
                        case .id(let id):
                            if id == refId { return true }
                        case .object(let obj):
                            if obj.id == refId { return true }
                        }
                        return false
                    })
                })
                let matchWithoutRef = allTableModel.filter({ cellModel -> Bool in
                    return cellModel.activeMatch.referees.count == 0
                })
                
                cellModels.append(contentsOf: refInside)
                cellModels.append(contentsOf: matchWithoutRef)
                //            if cellModels.count == 0 {
                //                self.getView().setState(state: .empty)
                //            }
                self.getView().onFetchModelSuccess(dataModel: cellModels)
            case .message(let message):
                self.getView().onFetchModelMessage(message: message)
            case .failure(let error):
                self.getView().onFetchModelFailure(error: error)
            }
        }
    }
    
    private func prepareTableData(activeMatches: ActiveMatches, referees: Players, clubs: [Club]) -> [RefereeEditMatchesLKTableViewCell.CellModel] {
        var cellModels: [RefereeEditMatchesLKTableViewCell.CellModel] = []
        
        let activeMatches = activeMatches
        for element in activeMatches.matches {
            
            let teamOne = clubs.filter({ (soloClub) -> Bool in
                if element.teamOne.club == soloClub.club.id {
                    return true
                }
                return false
            }).first?.club ?? nil
            let teamTwo = clubs.filter({ (soloClub) -> Bool in
                if element.teamTwo.club == soloClub.club.id {
                    return true
                }
                return false
            }).first?.club ?? nil
            
            let referee1 = element.referees.filter({ (referee) -> Bool in
                return referee.type == .firstReferee
//                return referee.getRefereeType() == Referee.RefereeType.referee1
            }).first
            
            var ref1: Person?
            if referee1 != nil {
                ref1 = referees.people.filter({ (person) -> Bool in
                    return referee1!.person!.orEqual(person.id, { $0.id == person.id })
//                    return -referee1?.person == person.id
                }).first
            }
            
            let referee2 = element.referees.filter({ (referee) -> Bool in
                return referee.type == .secondReferee
//                return referee.getRefereeType() == Referee.RefereeType.referee2
            }).first
            var ref2: Person?
            if referee2 != nil {
                ref2 = referees.people.filter({ (person) -> Bool in
                    return referee2!.person!.orEqual(person.id, { $0.id == person.id })
//                    return referee2?.person == person.id
                }).first
            }
            
            let referee3 = element.referees.filter({ (referee) -> Bool in
                return referee.type == .thirdReferee
//                return referee.getRefereeType() == Referee.RefereeType.referee3
            }).first
            var ref3: Person?
            if referee3 != nil {
                ref3 = referees.people.filter({ (person) -> Bool in
                    return referee3!.person!.orEqual(person.id, { $0.id == person.id })
//                    return referee3?.person == person.id
                }).first
            }
            
            let timekeeper = element.referees.filter({ (referee) -> Bool in
                return referee.type == .timekeeper
//                return referee.getRefereeType() == Referee.RefereeType.timekeeper
            }).first
            var timekeep: Person?
            if timekeeper != nil {
                timekeep = referees.people.filter({ (person) -> Bool in
                    return timekeeper!.person!.orEqual(person.id, { $0.id == person.id })
//                    return timekeeper?.person == person.id
                }).first
            }
            
            let cell = RefereeEditMatchesLKTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne, clubTeamTwo: teamTwo, referee1: ref1, referee2: ref2, referee3: ref3, timekeeper: timekeep)
            cellModels.append(cell)
            
        }
        
        return cellModels
    }
}
