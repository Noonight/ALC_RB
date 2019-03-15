//
//  RegistrationPresenter.swift
//  ALC_RB
//
//  Created by ayur on 22.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol RegistrationView: MvpView {
    
    func registrationComplete(authUser: AuthUser)
    
    func registrationError(error: Error)
    
    func replaceUserLKVC(authUser: AuthUser)
    
}

class RegistrationPresenter: MvpPresenter<RegistrationViewController> {
    
    let apiService = ApiRequests()
    
    func registration(userData: Registration, profileImage: UIImage) {
        apiService.post_registration(userData: userData, profileImage: profileImage, response_success: { (authUser) in
            self.getView().registrationComplete(authUser: authUser)
        }) { (error) in
            self.getView().registrationError(error: error)
        }
    }
    
}
