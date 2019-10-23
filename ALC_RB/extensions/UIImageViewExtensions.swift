//
//  UIImageViewExtensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 24/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Lightbox
import Kingfisher

enum ResultLoadImage {
    case success(UIImage)
    case failure(Error)
}

extension UIImageView {
    
    func kfLoadRoundedImage(path: String, placeholder: UIImage? = UIImage(named: "ic_logo")) {
        let url = ApiRoute.getImageURL(image: path)
        let processor = DownsamplingImageProcessor(size: self.frame.size)
            .append(another: CroppingImageProcessorCustom(size: self .frame.size))
            .append(another: RoundCornerImageProcessor(cornerRadius: self.getHalfWidthHeight()))
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    func kfLoadImage(path: String?, placeholder: UIImage? = UIImage(named: "ic_logo")) {
        
        guard let imagePath = path else { return }
        Print.m(imagePath)
        let url = ApiRoute.getImageURL(image: imagePath)
        Print.m(url.absoluteString)
        let processor = DownsamplingImageProcessor(size: self.frame.size)
//            .append(another: CroppingImageProcessorCustom(size: self .frame.size))
        
        self.kf.indicatorType = .none
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    func kfLoadImage(path: String?, placeholder: UIImage? = UIImage(named: "ic_logo"), complete: @escaping (ResultLoadImage) -> ()) {
            
        guard let imagePath = path else { return }
        let url = ApiRoute.getImageURL(image: imagePath)
        let processor = DownsamplingImageProcessor(size: self.frame.size)
            //SVGProcessor(size: self.frame.size)
//            .append(another: DownsamplingImageProcessor(size: self.frame.size))
        
        //                .append(another: CroppingImageProcessorCustom(size: self .frame.size))
        
            self.kf.indicatorType = .none
            self.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { result in
                    switch result
                    {
                    case .success(let image):
                        complete(.success(image.image))
                    case .failure(let error):
                        complete(.failure(error))
                    }
            }
        }
    
    func animateTap()
    {
        alpha = 0.75
        UIView.animate(withDuration: 0.5)
        {
            self.alpha = 1.0
        }
    }
    
    func cropAndRound() {
        self.image = self.cropAndCenteringImage(image: self.image!, width: Double(self.frame.width), height: Double(self.frame.height))
        self.setRounded()
        self.backgroundColor = UIColor.clear
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
    
    func getHalfWidthHeight() -> CGFloat {
        return min(self.frame.width, self.frame.height) / 2
    }
}

extension CGSize {
    func getHalfWidthHeight() -> CGFloat {
        return min(width, height) / 2
    }
}

extension UIImage {
    
    func addText(textToDraw: NSString, atCorner: Int, textColor: UIColor?, textFont: UIFont?) -> UIImage {
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.white
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 50)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        UIGraphicsBeginImageContext(size)
        
        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font.rawValue: _textFont,
            NSAttributedString.Key.foregroundColor: _textColor,
            NSAttributedString.Key.paragraphStyle: titleParagraphStyle
            ] as! [NSAttributedString.Key : Any]
        
        // get the bounding-box for the string
        var stringSize = textToDraw.size(withAttributes: textFontAttributes)
        
        // draw in rect functions like whole numbers
        stringSize.width = ceil(stringSize.width)
        stringSize.height = ceil(stringSize.height)
        
        var rect = CGRect(origin: CGPoint.zero, size: self.size)
        
        switch atCorner {
            
        case 1:
            // top-right
            titleParagraphStyle.alignment = .right
            
        case 2:
            // bottom-right
            rect.origin.y = self.size.height - stringSize.height
            titleParagraphStyle.alignment = .right
            
        case 3:
            // bottom-left
            rect.origin.y = self.size.height - stringSize.height
            
        default:
            // top-left
            // don't need to change anything here
            break
            
        }
        
        // Draw the text into an image
        textToDraw.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }
    
//    func appendText(drawText text: String, atPoint point: CGPoint) -> UIImage {
//        let textColor = UIColor.white
//        let textFont = UIFont.systemFont(ofSize: 17)
////        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
//
//        let scale = UIScreen.main.scale
//        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
//
//        let textFontAttributes = [
//            NSAttributedString.Key.font: textFont,
//            NSAttributedString.Key.foregroundColor: textColor,
//            ] as [NSAttributedString.Key : Any]
//        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
//
//        let rect = CGRect(origin: point, size: self.size)
//        text.draw(in: rect, withAttributes: textFontAttributes)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
    
//    func cropAndRound() {
//        self.image = self.cropAndCenteringImage(image: self.image!, width: Double(self.frame.width), height: Double(self.frame.height))
//        self.setRounded()
//        self.backgroundColor = UIColor.clear
//    }
//
//    fileprivate func setRounded() {
//        let newRadius = min(frame.width, frame.height) / 2
//        layer.cornerRadius = newRadius
//        layer.masksToBounds = true
//    }
    
    fileprivate func cropAndCenteringImage(width: Double, height: Double) -> UIImage {
        
        let minRadius = min(width, height)
        
        let imageScale = self.scale
        
        let cgimage = self.cgImage!
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
        let image: UIImage = UIImage(cgImage: imageRef, scale: imageScale, orientation: self.imageOrientation)
        
        return image
    }
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
