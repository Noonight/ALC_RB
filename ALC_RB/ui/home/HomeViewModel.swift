//
//  HomeViewModel.swift
//  ALC_RB
//
//  Created by ayur on 19.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class HomeViewModel {
    
    private var announces: Announce?
    private var message: SingleLineMessage?
    private var error: RequestError?
    
    private let dataManager = ApiRequests()
    
    // MARK: PREPARE
    
    func prepareAnnounces() -> [AnnounceElement]? {
        return announces?.announces
    }
    
    func prepareMessage() -> SingleLineMessage? {
        return self.message
    }
    
    func prepareError() -> RequestError? {
        return self.error
    }
    
    // MARK: API
    
    func fetchAnnounces(completed: @escaping () -> ()) {
        self.dataManager.get_announces { result in
            Print.m("result here")
//            Print.m(result)
            self.clearAll()
            switch result
            {
            case .success(let announces):
                Print.m("announces")
                self.announces = announces
            case .message(let message):
                Print.m("message")
                self.message = message
            case .failure(let error):
                Print.m("error")
                self.error = error
            }
            completed()
        }
    }
    
    // MARK: HELPER
    
    func clearAll() {
        self.announces = nil
        self.message = nil
        self.error = nil
    }
    
}
