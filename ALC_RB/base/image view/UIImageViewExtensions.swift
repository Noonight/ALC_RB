//
//  UIImageViewExtensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit


extension UIImageView {
    func cacheImage(urlString: String){
        
//        activityIndicator.startAnimating()
        
        let url = URL(string: urlString)
        
//        image = nil
        
        if let imageFromCache = imageCache2.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.cropAndRound()
//            activityIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in

            if error != nil {
                Print.m("Error loading image: \(error)")
//                self.activityIndicator.stopAnimating()
                return
            }

            if data != nil {
                DispatchQueue.main.async {
                    
                    guard let imageToCache = UIImage(data: data!) else
                    {
                        return
                    }
                    imageCache2.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    self.cropAndRound()
//                    self.activityIndicator.stopAnimating()
                }
            }
            }.resume()
    }
}

//extension UIImageView {
//
//    fileprivate var activityIndicator: UIActivityIndicatorView {
//        get {
//            let activityIndicator = UIActivityIndicatorView(style: .gray)
//            activityIndicator.hidesWhenStopped = true
//            activityIndicator.center = CGPoint(x:self.frame.width/2,
//                                               y: self.frame.height/2)
//            activityIndicator.stopAnimating()
//            self.addSubview(activityIndicator)
//            return activityIndicator
//        }
//    }
//
//}

extension UIImageView {
    
    func cropAndRound() {
        self.image = self.cropAndCenteringImage(image: self.image!, width: Double(self.frame.width), height: Double(self.frame.height))
        self.setRounded()
    }
    
    fileprivate func setRounded() {
        let newRadius = min(frame.width, frame.height) / 2
        layer.cornerRadius = newRadius
        layer.masksToBounds = true
    }
    
    fileprivate func cropAndCenteringImage(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let minRadius = min(width, height)
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(minRadius)
        var cgheight: CGFloat = CGFloat(minRadius)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}
