//
//  LeagueDetailViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 17.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LeagueDetailViewModel {
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<Error?> = PublishSubject()
    // as variable and as observable object, subject
    let leagueDetailModel = BehaviorRelay<LeagueDetailModel?>(value: nil)
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    // MARK: TODO
    // fetch 
}
