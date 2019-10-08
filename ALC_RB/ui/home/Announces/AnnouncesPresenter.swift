//
//  AnnouncesPresenter.swift
//  ALC_RB
//
//  Created by ayur on 24.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class AnnouncesPresenter {
    
    private let dataManager: ApiRequests!

    init (dataManager: ApiRequests) {
        self.dataManager = dataManager
    }
    
    func fetchAnnounces(success: @escaping ([Announce]) -> (), r_message: @escaping (SingleLineMessage) -> (), all_failure: @escaping (Error) -> (), server_failure: @escaping (Error) -> (), local_failure: @escaping (Error) -> () ) {
        self.dataManager.get_announces { result in
            switch result
            {
            case .success(let announces):
                success(announces)
            case .message(let message):
                r_message(message)
            case .failure(.alamofire(let error)):
                all_failure(error)
            case .failure(.server(let error)):
                server_failure(error)
            case .failure(.local(let error)):
                local_failure(error)
            }
        }
    }
    
}
