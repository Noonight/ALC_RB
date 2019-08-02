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
    
    func onResponseEditMatchSuccess(soloMatch: SoloMatch)
    func onResponseEditMatchMessage(message: SingleLineMessage)
    func onResponseEditMatchFailure(error: Error)
}

class RefereeEditMatchesLKPresenter: MvpPresenter<RefereeEditMatchesLKTableViewController> {
    let dataManager = ApiRequests()
    
    var cache: EditMatchReferees?
    
    func requestEditMatchReferee(token: String, editMatchReferees: EditMatchReferees) {
        self.cache = editMatchReferees
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees, response_success: { soloMatch in
            self.getView().onResponseEditMatchSuccess(soloMatch: soloMatch)
//            success(soloMatch)
        }, response_message: { message in
            self.getView().onResponseEditMatchMessage(message: message)
//            message_single(message)
        }) { error in
//            failure(error)
            self.getView().onResponseEditMatchFailure(error: error)
        }
    }
    
    func fetch(refId: String) {
        Print.m("fetching")
        self.getView().setState(state: .loading)
        dataManager.getActiveMatchesForView(get_success: { (activeMatches, referees, clubs) in
            
            var cellModels: [RefereeEditMatchesLKTableViewCell.CellModel] = []
            let allTableModel = self.prepareTableData(activeMatches: activeMatches, referees: referees, clubs: clubs)
            let refInside = allTableModel.filter({ cellModel -> Bool in
                return cellModel.activeMatch.referees.contains(where: { referee -> Bool in
                    return referee.person == refId
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
            
        }, get_message: { message in
            self.getView().onFetchModelMessage(message: message)
        }) { (error) in
            self.getView().onFetchModelFailure(error: error)
        }
    }
    
    private func prepareTableData(activeMatches: ActiveMatches, referees: Players, clubs: [SoloClub]) -> [RefereeEditMatchesLKTableViewCell.CellModel] {
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
                return referee.getRefereeType() == Referee.RefereeType.referee1
            }).first
            
            var ref1: Person?
            if referee1 != nil {
                ref1 = referees.people.filter({ (person) -> Bool in
                    return referee1?.person == person.id
                }).first
            }
            
            let referee2 = element.referees.filter({ (referee) -> Bool in
                return referee.getRefereeType() == Referee.RefereeType.referee2
            }).first
            var ref2: Person?
            if referee2 != nil {
                ref2 = referees.people.filter({ (person) -> Bool in
                    return referee2?.person == person.id
                }).first
            }
            
            let referee3 = element.referees.filter({ (referee) -> Bool in
                return referee.getRefereeType() == Referee.RefereeType.referee3
            }).first
            var ref3: Person?
            if referee3 != nil {
                ref3 = referees.people.filter({ (person) -> Bool in
                    return referee3?.person == person.id
                }).first
            }
            
            let timekeeper = element.referees.filter({ (referee) -> Bool in
                return referee.getRefereeType() == Referee.RefereeType.timekeeper
            }).first
            var timekeep: Person?
            if timekeeper != nil {
                timekeep = referees.people.filter({ (person) -> Bool in
                    return timekeeper?.person == person.id
                }).first
            }
            
            let cell = RefereeEditMatchesLKTableViewCell.CellModel(activeMatch: element, clubTeamOne: teamOne!, clubTeamTwo: teamTwo!, referee1: ref1, referee2: ref2, referee3: ref3, timekeeper: timekeep)
            cellModels.append(cell)
            
        }
        
        return cellModels
    }
}
