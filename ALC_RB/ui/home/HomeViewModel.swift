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
    
//    func fetchAnnounces(completed: @escaping (ResultMy<Announce, RequestError>) -> ()) {
//        dataManager.get_announces(success: { announces in
//            completed(.success())
//        }) { error in
//            failure(error)
//        }
//    }
    
    func fetchAnnounces(success: @escaping (Announce) -> (), rMessage: @escaping (SingleLineMessage) -> (), failureAll: @escaping (Error) -> (), failureServer: @escaping (Error) -> (), failureLocal: @escaping (Error) -> ()) {
        dataManager.get_announces { result in
            switch result
            {
            case .success(let announces):
                success(announces)
            case .message(let message):
                rMessage(message)
            case .failure(.alamofire(let error)):
                failureAll(error)
            case .failure(.server(let error)):
                failureServer(error)
            case .failure(.local(let error)):
                failureLocal(error)
            }
        }
    }
    
}
