//
//  ClubEditPresenter.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol ClubEditLKView : MvpView {
    
    func getClubLogoSuccess(image: UIImage)
    func getClubLogoFailure(error: Error)
    
}

class ClubEditLKPresenter : MvpPresenter<ClubEditLKViewController> {
    
    let apiService = ApiRequests()
    
    func editClubInfo() {
        
    }
    
    func getClubLogo(byPath image: String) {
        apiService.get_image(imagePath: image, get_success: { (image) in
            self.getView().getClubLogoSuccess(image: image)
        }) { (error) in
            self.getView().getClubLogoFailure(error: error)
        }
    }
    
}
