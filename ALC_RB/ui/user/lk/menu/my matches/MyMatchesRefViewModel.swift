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
    
    var refreshing: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error> = PublishSubject()
    var participationMatches: Variable<[ParticipationMatch]> = Variable<[ParticipationMatch]>([])
    var tableModel: PublishSubject<[MyMatchesRefTableViewCell.CellModel]> = PublishSubject()
    
    var dataManager: ApiRequests?
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch()
    {
        if participationMatches.value.count > 0 {
            refreshing.onNext(true)
            
            self.dataManager?.get_forMyMatches(participationMatches: participationMatches.value, get_success: { (cellModels) in
                self.tableModel.onNext(cellModels)
                self.refreshing.onNext(false)
            }, get_failure: { (error) in
                self.error.onNext(error)
            })
        } else {
            self.tableModel.onNext([])
//            self.error.onNext(Error)
        }
    }
}
