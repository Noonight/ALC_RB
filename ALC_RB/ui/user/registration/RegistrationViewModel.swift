//
//  RegistrationViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 22.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RegistrationViewModel {
    
    var regions: PublishSubject<[RegionMy]> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var message: PublishSubject<SingleLineMessage> = PublishSubject()
    var choosedRegion = BehaviorRelay<RegionMy?>(value: nil)
    
    var authorizedUser: PublishSubject<AuthUser> = PublishSubject()
    var choosedImage = BehaviorRelay<UIImage?>(value: nil)
    
    private let regionApi: RegionApi
    private let personApi: PersonApi
    private let userDefaults: UserDefaultsHelper
    
    init(regionApi: RegionApi, personApi: PersonApi) {
        self.regionApi = regionApi
        self.personApi = personApi
        self.userDefaults = UserDefaultsHelper()
    }
    
    func fetch() {
        loading.onNext(true)
        regionApi.get_region { result in
            self.loading.onNext(false)
            switch result {
            case .success(let regions):
                self.regions.onNext(regions)
            case .message(let message):
                self.message.onNext(message)
            case .failure(.error(let error)):
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("Not expected data")
            }
        }
    }
    
    func registration(userData: Registration) {
        loading.onNext(true)
        personApi.post_registration(userData: userData, profileImage: choosedImage.value) { response in
            self.loading.onNext(false)
            switch response {
            case .success(let authUser):
                self.authorizedUser.onNext(authUser)
                self.authorizedUser.onCompleted()
                self.userDefaults.setAuthorizedUser(user: authUser)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
