//
//  Static functions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 25.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

func kfLoadImage(imagePath: String, complete: @escaping (ResultLoadImage) -> ()) {
    
    let url = ApiRoute.getImageURL(image: imagePath)
    
    KingfisherManager.shared.retrieveImage(
        with: url,
        options: [
        .cacheOriginalImage
        ],
        progressBlock: nil) { result in
            switch result {
            case .success(let image):
                complete(.success(image.image))
            case .failure(let error):
                complete(.failure(error))
            }
    }
}
