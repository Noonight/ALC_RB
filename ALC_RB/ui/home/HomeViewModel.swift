//
//  HomeViewModel.swift
//  ALC_RB
//
//  Created by ayur on 19.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeViewModel {
    
    private var announces = Announce()
    
    private let dataManager = ApiRequests()
    
    // MARK: PREPARE
    
    func prepareAnnounces() -> [AnnounceElement] {
        return announces.announces
    }
    
    // MARK: API
    
    func fetchAnnounces(completed: @escaping (ResultMy<Announce, RequestError>) -> ()) {
        dataManager.get_announces(success: { announces in
            
        }) { error in
            failure(error)
        }
    }
    
}
