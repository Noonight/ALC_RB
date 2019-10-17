//
//  LeagueDetailViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift

final class LeagueDetailViewModel {
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
}
