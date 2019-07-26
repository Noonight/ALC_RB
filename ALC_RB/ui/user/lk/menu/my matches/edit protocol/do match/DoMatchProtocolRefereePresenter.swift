//
//  DoMatchProtocolRefereePresenter.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

protocol DoMatchProtocolRefereeView: MvpView {
    
}

class DoMatchProtocolRefereePresenter: MvpPresenter<DoMatchProtocolRefereeViewController> {
    
    let dataManager = ApiRequests()
    
    
}
