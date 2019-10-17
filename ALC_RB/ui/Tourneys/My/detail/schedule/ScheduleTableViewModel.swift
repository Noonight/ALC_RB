//
//  ScheduleTableViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleTableViewModel {
    
    var items: PublishSubject<[MatchScheduleModelItem]> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch() {
        
    }
}
