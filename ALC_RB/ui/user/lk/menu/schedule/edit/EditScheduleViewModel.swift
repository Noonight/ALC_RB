//
//  EditScheduleViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
//import RxCocoa

class EditScheduleViewModel {
    struct SlidersData {
        var defaultValues: [Referee]
        var allReferees: Players
        
        init(defaultValues: [Referee], allReferees: Players) {
            self.defaultValues = defaultValues
            self.allReferees = allReferees
        }
        
        init() {
            defaultValues = []
            allReferees = Players()
        }
        
//        func setReferee(oldRefId: String, newRefId: String) {
//            defaultValues.swapAt(defaultValues.firstIndex(where: { (ref) -> Bool in
//                return re == oldRefId
//            }), defaultValues.append(Referee()))
//        }
    }
    
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var message = PublishSubject<SingleLineMessage>()
//    var activeMatch: PublishSubject<ActiveMatch> = PublishSubject()
//    var referees: PublishSubject<Players> = PublishSubject()
    
    var comingCellModel: Variable<ScheduleRefTableViewCell.CellModel> = Variable<ScheduleRefTableViewCell.CellModel>(ScheduleRefTableViewCell.CellModel())
    var comingReferees: Variable<Players> = Variable<Players>(Players())
    
    var sliderData: PublishSubject<SlidersData> = PublishSubject()
    
    var editedMatch = Variable<SoloMatch?>(nil)
    
    private let dataManager: ApiRequests
    
    var cache: EditMatchReferees?
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchReferees() {
        self.refreshing.onNext(true)
        dataManager.get_referees(get_success: { (referees) in
            
            self.refreshing.onNext(false)

        }) { (error) in
            self.error.onNext(error)
        }
    }
    
    func fetchLeagueInfo(id: String, success: @escaping (LILeagueInfo)->(), r_message: @escaping (SingleLineMessage) -> (), failure: @escaping (Error)->()) {
//        dataManager.get_tournamentLeague(id: id, get_success: { leagueInfo in
//            success(leagueInfo)
//        }, get_error: { error in
//            failure(error)
////            Print.m(error)
//        })
        dataManager.get_tournamentLeague(id: id) { result in
            switch result {
            case .success(let league):
                success(league)
            case .message(let message):
                r_message(message)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (SoloMatch)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
//        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees, response_success: { soloMatch in
//                success(soloMatch)
//            }, response_message: { message in
//                message_single(message)
//            }) { error in
//                failure(error)
//            }
        self.refreshing.onNext(true)
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees) { result in
            self.refreshing.onNext(false)
            switch result {
            case .success(let match):
                self.editedMatch.value = match
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(let error):
                Print.m(error)
                self.error.onNext(error)
            }
        }
    }
    
//    func acceptMatch(token: String, protocolID: String, success: @escaping (SingleLineMessage) -> (), failure: @escaping (Error) -> ()) {
//        dataManager.post_acceptProtocol(token: token, id: protocolID, success: { message in
//            success(message)
//        }) { error in
//            failure(error)
//        }
//    }
    
}
