//
//  Image.swift
//  ALC_RB
//
//  Created by ayur on 29.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

extension CGImage {
    
    func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
}
