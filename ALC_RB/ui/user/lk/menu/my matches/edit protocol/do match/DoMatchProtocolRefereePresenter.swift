//
//  DoMatchProtocolRefereePresenter.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class DoMatchProtocolRefereePresenter {
    
    private let protocolApi = ProtocolApi()
    
    func saveProtocolEvents(editProtocol: EditProtocol, resultMy: @escaping (ResultMy<Match, RequestError>) -> ()) {
        protocolApi.post_changeProtocol(newProtocol: editProtocol, resultMy: resultMy)
    }
    
}
