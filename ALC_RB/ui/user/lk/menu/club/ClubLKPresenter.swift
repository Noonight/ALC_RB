//
//  ClubLKPresenter.swift
//  ALC_RB
//
//  Created by ayur on 19.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

protocol ClubLKView: MvpView {
    
    func getClubsSuccess(clubs: Clubs)
    func getClubsFailure(error: Error)
    
    func getClubImageSuccess(image: UIImage)
    func getClubImageFailure(error: Error)
    
}

class ClubLKPresenter: MvpPresenter<ClubLKViewController> {
    
    let apiService = ApiRequests()
    
    func getClubs() {
        self.getView().setState(state: .loading)
        apiService.get_clubs(get_success: { (clubs) in
            self.getView().getClubsSuccess(clubs: clubs)
        }) { (error) in
            self.getView().getClubsFailure(error: error)
        }
    }
    
    func getImage(imagePath: String) {
        apiService.get_image(imagePath: imagePath, get_success: { (image) in
            self.getView().getClubImageSuccess(image: image)
        }) { (error) in
            self.getView().getClubImageFailure(error: error)
        }
    }
    
}
