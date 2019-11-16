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
    
    func editClubInfoSuccess(soloClub: Club)
    func editClubInfoFailure(error: Error)
    
}

class ClubEditLKPresenter : MvpPresenter<ClubEditLKViewController> {
    
    let apiService = ApiRequests()
    
    struct EditClubInfoCache {
        var editClubInfo: EditClubInfo
        var image: UIImage?
        
        init(clubInfo: EditClubInfo, image: UIImage?) {
            self.editClubInfo = clubInfo
            self.image = image
        }
    }
    
    var editClubInfoCache: EditClubInfoCache?
    
    func editClubInfo(token: String, clubInfo: EditClubInfo, image: UIImage?) {
        editClubInfoCache = EditClubInfoCache(clubInfo: clubInfo, image: image)
//        apiService.post_editClubInfo(token: token, clubInfo: clubInfo, clubImage: image, response_success: { (soloClub) in
//            self.getView().editClubInfoSuccess(soloClub: soloClub)
//        }) { (error) in
//            self.getView().editClubInfoFailure(error: error)
//        }
    }
    
    func getClubLogo(byPath image: String) {
        apiService.get_image(imagePath: image, get_success: { (image) in
            self.getView().getClubLogoSuccess(image: image)
        }) { (error) in
            self.getView().getClubLogoFailure(error: error)
        }
    }
    
}
