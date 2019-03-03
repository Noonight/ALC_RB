//
//  ChangeProfilePresenter.swift
//  ALC_RB
//
//  Created by ayur on 28.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol ChangeProfileView: MvpView {
    
    func changeProfileSuccessful(soloUser: SoloPerson)
    
    func changeProfileFailure(error: Error)
    
    func getProfilePhotoSuccessful(image: UIImage)
    
    func getProfilePhotoFailure(error: Error)
    
}

class ChangeProfilePresenter: MvpPresenter<ChangeProfileViewController> {
    
    let apiService = ApiRequests()
    
    func editProfile(token: String, profileInfo: EditProfile, profileImage: UIImage) {
        apiService.post_edit_profile(token: token, profileInfo: profileInfo, profileImage: profileImage, get_good: { (soloPerson) in
            self.getView().changeProfileSuccessful(soloUser: soloPerson)
            Print.l()
        }) { (error) in
            self.getView().changeProfileFailure(error: error)
        }
    }
    
    func photoProfile(imagePath: String) {
        apiService.get_image(imagePath: imagePath, get_success: { (image) in
            self.getView().getProfilePhotoSuccessful(image: image)
        }) { (error) in
            self.getView().getProfilePhotoFailure(error: error)
        }
    }
    
}
