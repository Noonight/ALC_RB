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
    
    func registration(userData: Registration) {
        apiService.post_registration(userData: userData, get_reg_auth_user: { (authUser) in
            self.getView().registrationComplete(authUser: authUser)
        }) { (error) in
            self.getView().registrationError(error: error)
        }
    }
    
}
