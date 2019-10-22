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
    
    private let dataManager: ApiRequests
    private let userDefaults: UserDefaultsHelper
    
    init(dataManager: ApiRequests) {
        self.dataManager = dataManager
        self.userDefaults = UserDefaultsHelper()
    }
    
    func fetch() {
        loading.onNext(true)
        dataManager.get_regions { result in
            self.loading.onNext(false)
            switch result {
            case .success(let regions):
                self.regions.onNext(regions)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
    func registration(userData: Registration) {
        loading.onNext(true)
        dataManager.post_registration(userData: userData, profileImage: choosedImage.value) { response in
            self.loading.onNext(false)
            switch response {
            case .success(let authUser):
                self.authorizedUser.onNext(authUser)
                self.userDefaults.setAuthorizedUser(user: authUser)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
