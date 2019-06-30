//
//  EditScheduleViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

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
//    var activeMatch: PublishSubject<ActiveMatch> = PublishSubject()
//    var referees: PublishSubject<Players> = PublishSubject()
    
    var comingCellModel: Variable<ScheduleRefTableViewCell.CellModel> = Variable<ScheduleRefTableViewCell.CellModel>(ScheduleRefTableViewCell.CellModel())
    var comingReferees: Variable<Players> = Variable<Players>(Players())
    
    var sliderData: PublishSubject<SlidersData> = PublishSubject()
    
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
    
    func editMatchReferees(token: String, editMatchReferees: EditMatchReferees, success: @escaping (SoloMatch)->(), message_single: @escaping (SingleLineMessage)->(), failure: @escaping (Error)->()) {
        self.cache = editMatchReferees
        dataManager.post_matchSetReferee(token: token, editMatchReferees: editMatchReferees, response_success: { soloMatch in
                success(soloMatch)
            }, response_message: { message in
                message_single(message)
            }) { error in
                failure(error)
            }
    }
    
}
