//
//  MyMatchesRefViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

class MyMatchesRefViewModel {
    
    var message = PublishSubject<SingleLineMessage>()
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var participationMatches: Variable<[ParticipationMatch]> = Variable<[ParticipationMatch]>([])
    var tableModel: PublishSubject<[MyMatchesRefTableViewCell.CellModel]> = PublishSubject()
//    var firstInit: Variable<Bool> = Variable<Bool>(true)
    
    var dataManager: ApiRequests?
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch(closure: @escaping () -> ())
    {
        Print.m(participationMatches.value)
        if participationMatches.value.count > 0 {
            refreshing.onNext(true)
            
            self.dataManager?.get_forMyMatches(participationMatches: participationMatches.value, get_success: { (cellModels) in
                Print.m("request for my matches complete with success code")
                dump(cellModels)
                self.tableModel.onNext(cellModels)
                self.refreshing.onNext(false)
                closure()
//                Print.m(cellModels)
            }, get_failure: { (error) in
                self.error.onNext(error)
            })
        } else {
            self.tableModel.onNext([])
            closure()
//            self.error.onNext(Error)
        }
        
        if participationMatches.value.count > 0 {
            refreshing.onNext(true)
            dataManager?.get_myMatchesCellModels(participationMatches: participationMatches.value, resultMy: { result in
                self.refreshing.onNext(false)
                switch result {
                case .success(let cells):
                    self.tableModel.onNext(cells)
                case .message(let message):
                    self.message.onNext(message)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
        }
    }
    
    func fetchLeagueInfo(id: String, success: @escaping (LILeagueInfo)->(), failure: @escaping (Error)->()) {
        dataManager?.get_tournamentLeague(id: id, get_success: { leagueInfo in
            success(leagueInfo)
        }, get_error: { error in
            failure(error)
        })
    }
}
