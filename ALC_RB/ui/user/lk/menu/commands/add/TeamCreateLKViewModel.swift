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

final class TeamCreateLKViewModel {
    
    var loading = PublishSubject<Bool>()
    var error = PublishSubject<Error?>()
    var message = PublishSubject<SingleLineMessage>()
    
    private let teamApi: TeamApi
    
    init(teamApi: TeamApi) {
        self.teamApi = teamApi
    }
    
    func request() {
        
    }
    
}
