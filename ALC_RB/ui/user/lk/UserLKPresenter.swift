//
//  UserLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 03.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol UserLKView: MvpView {
    
    func getProfileImageSuccessful(image: UIImage)
    
    func getProfileImageFailure(error: Error)
    
//    func fetchRefereesSuccess(referees: Players)
//    func fetchRefereesFailure(error: Error)
}

class UserLKPresenter: MvpPresenter<UserLKViewController> {
    
    private let apiService = ApiRequests()
    
    func getProfileImage(imagePath: String) {
        apiService.get_image(imagePath: imagePath, get_success: { (image) in
            self.getView().getProfileImageSuccessful(image: image)
        }) { (error) in
            self.getView().getProfileImageFailure(error: error)
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
