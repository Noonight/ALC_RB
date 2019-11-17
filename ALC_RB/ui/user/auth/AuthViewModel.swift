//
//  AuthViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 23.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AuthViewModel {
    
    let authUser = PublishSubject<AuthUser>()
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    
    private let dataManager: ApiRequests
    private let personApi: PersonApi
    lazy var userDefaults = UserDefaultsHelper()
    
    init(dataManager: ApiRequests, personApi: PersonApi) {
        self.dataManager = dataManager
        self.personApi = personApi
    }
    
    func authorization(userData: SignIn) {
        loading.onNext(true)
        personApi.post_authorization(userData: userData) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let authUser):
                Print.m(authUser)
                self.authUser.onNext(authUser)
                self.authUser.onCompleted()
                self.userDefaults.setAuthorizedUser(user: authUser)
            case .message(let message):
                Print.m(message)
                self.message.onNext(message)
            case .failure(let error):
                Print.m(error)
                self.error.onNext(error)
            }
        }
    }
    
}
