//
//  AuthPresenter.swift
//  ALC_RB
//
//  Created by ayur on 22.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol AuthView: MvpView {
    
    func authorizationComplete(authUser: AuthUser)
    func authorizationMessage(message: SingleLineMessage)
    func authorizationError(error: Error)
    
    func replaceUserLKVC(authUser: AuthUser)
}

class AuthPresenter: MvpPresenter<AuthViewController> {
    
    let apiService = ApiRequests()
    
    func signIn(userData: SignIn) {
        apiService.post_authorization(userData: userData, get_auth_user: { authUser in
            self.getView().authorizationComplete(authUser: authUser)
        }, get_error: { error in
            self.getView().authorizationError(error: error)
        }) { message in
            self.getView().authorizationMessage(message: message)
        }
    }
    
}
