//
//  ApiRequests.swift
//  ALC_RB
//
//  Created by ayur on 25.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiRequests {
    
    func post_authorization(userData: SignIn, get_auth_user: @escaping (AuthUser) -> (), get_error: @escaping (Error) -> ()) {
        let params: [String: Any] = [
            SignIn.Fields.login.rawValue: userData.login,
            SignIn.Fields.password.rawValue: userData.password
        ]
        Alamofire
            .request(ApiRoute.getApiURL(.post_auth), method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate()
            .responseAuthUser { (response) in
                switch response.result {
                case .success:
                    if let authUser = response.result.value {
                        get_auth_user(authUser)
                    }
                case .failure(let error):
                    print(error)
                    get_error(error)
                }
        }
    }
    
    func post_registration(userData: Registration, get_reg_auth_user: @escaping (AuthUser) -> (), get_error: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getApiURL(.post_reg), method: .post, parameters: userData.toParams(), encoding: JSONEncoding.default, headers: [:])
            .validate()
            .responseAuthUser { (response) in
                switch response.result {
                case .success:
                    if let authUser = response.result.value {
                        get_reg_auth_user(authUser)
                    }
                case .failure(let error):
                    get_error(error)
                }
        }
    }
    
    func post_edit_profile(token: String, profileInfo: EditProfile, profileImage: UIImage, response_success: @escaping (SoloPerson) -> (), response_failure: @escaping (Error) -> () ) {
        Alamofire
            .upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(profileImage.jpegData(compressionQuality: 1.0)!, withName: "photo", fileName: "jpg", mimeType: "image/jpg")
                for (key, value) in profileInfo.toParams() {
                    let strValue = value as! String
                    multipartFormData.append(strValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            },
                    usingThreshold: UInt64(),
                    to: ApiRoute.getApiURL(.post_edit_profile),
                    method: .post,
                    headers: ["auth" : token])
            { (result) in
                switch result {
                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (progress) in
//                    })

                    upload.responseSoloPerson(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            if let editedPerson = response.result.value {
                                response_success(editedPerson)
                            }
                        case .failure(let error):
                            response_failure(error)
                        }
                    })
                    
                case .failure(let error):
                    response_failure(error)
                }
            }
    }
    
    func get_image(imagePath: String, get_success: @escaping (UIImage) -> (), get_failure: @escaping (Error) -> ()) {
        Alamofire
            .request(ApiRoute.getImageURL(image: imagePath))
            .validate()
            .responseImage { (response) in
                switch response.result {
                case .success:
                    if let image = response.result.value {
                        get_success(image)
                    }
                case .failure(let error):
                    get_failure(error)
                }
        }
    }
    
}
