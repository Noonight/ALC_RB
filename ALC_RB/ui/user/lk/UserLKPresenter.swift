//
//  UserLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol UserLKView: MvpView {
    
//    func getProfileImageSuccessful(image: UIImage)
//
//    func getProfileImageFailure(error: Error)
    
//    func fetchRefereesSuccess(referees: Players)
//    func fetchRefereesFailure(error: Error)
    
    func onRefreshUserSuccessful(authUser: AuthUser)
    func onRefreshUserFailure(authUser: Error)
}

class UserLKPresenter: MvpPresenter<UserLKViewController> {
    
    private let personApi = PersonApi()
    
//    func getProfileImage(imagePath: String) {
//        apiService.get_image(imagePath: imagePath, get_success: { (image) in
//            self.getView().getProfileImageSuccessful(image: image)
//        }) { (error) in
//            self.getView().getProfileImageFailure(error: error)
//        }
//    }
    
    func refreshUser(token: String) {
        personApi.get_refreshAuthUser(token: token) { result in
            switch result {
            case .success(let authUser):
                self.getView().onRefreshUserSuccessful(authUser: authUser)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.getView().onRefreshUserFailure(authUser: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
//    func fetchReferees() {
//        apiService.get_referees(get_success: { (referees) in
//            self.getView().fetchRefereesSuccess(referees: referees)
//        }) { (error) in
//            self.getView().fetchRefereesFailure(error: error)
//        }
//    }
    
}
