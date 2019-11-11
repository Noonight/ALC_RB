//
//  EditProfileViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel {
    
    let loading = PublishSubject<Bool>()
    let message = PublishSubject<SingleLineMessage>()
    let error = PublishSubject<Error?>()
    
    let regionViewModel: RegionsViewModel
    let choosedImage = BehaviorRelay<UIImage?>(value: nil)
    let editedPerson = PublishSubject<SoloPerson>()
    var authorizedUser: AuthUser? {
        get {
            return userDefaults.getAuthorizedUser()
        }
    }
    
    let dataManager: ApiRequests
    let userDefaults = UserDefaultsHelper()
    
    init(dataManager: ApiRequests, regionApi: RegionApi) {
        self.dataManager = dataManager
        self.regionViewModel = RegionsViewModel(regionApi: regionApi)
    }
    
    func fetch() {
        regionViewModel.fetch()
    }
    
    func editProfile(profileInfo: EditProfile) {
        loading.onNext(true)
        dataManager.post_edit_profile(token: authorizedUser!.token, profileInfo: profileInfo, profileImage: choosedImage.value) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let person):
                var authPerson = self.userDefaults.getAuthorizedUser()
                authPerson?.person = person.person
                self.userDefaults.setAuthorizedUser(user: authPerson!)
                self.editedPerson.onNext(person)
            case .message(let message):
                self.message.onNext(message)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
    
}
