//
//  CommandCreateLKViewModel.swift
//  ALC_RB
//
//  Created by ayur on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CommandCreateLKViewModel {
    
    var tourneys = PublishSubject<[TourneyModelItem]>()
    var regions = PublishSubject<[RegionMy]>()
    var loading = PublishSubject<Bool>()
    var error = PublishSubject<Error?>()
    var message = PublishSubject<SingleLineMessage>()
    
    private let dataManager: ApiRequests
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetch() {
        
    }
    
    func fetchTourneys() {
        
    }
    
    func fetchRegions() {
        
    }
    
}
