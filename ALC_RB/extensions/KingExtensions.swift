//
//  KingExtensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

public struct CroppingImageProcessorCustom: ImageProcessor {
    
    public let identifier: String
    public let size: CGSize
    public let anchor: CGPoint
    
    public init(size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.size = size
        self.anchor = anchor
        self.identifier = "com.onevcat.Kingfisher.CroppingImageProcessorCustom(\(size)_\(anchor))"
    }
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
//            let imageValues = image.af_imageRoundedIntoCircle()
            return image.kf.scaled(to: options.scaleFactor).af_imageRoundedIntoCircle()
//                .kf.crop(to: size, anchorOn: anchor)
        case .data: return (DefaultImageProcessor.default >> self).process(item: item, options: options)
        }
    }
}

struct SVGProcessor: ImageProcessor {
    
    // `identifier` should be the same for processors with the same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier = "svgprocessor"
    var size: CGSize!
    init(size: CGSize) {
        self.size = size
    }
    // Convert input data/image to target image and return it.
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
        case .image(let image):
//            print("already an image")
            return image
        case .data(let data):
//            print("svg string")
            let image = SVGKImage(data: data)
            Print.m(data.kf.imageFormat == .unknown)
//            SVGKImage(contentsOfFile: data.kf.contains(jpeg: ImageFormat.JPEGMarker.))
            return image?.uiImage
        }
    }
}
//struct SVGCacheSerializer: CacheSerializer {
//    func image(with data: Data, options: KingfisherParsedOptionsInfo) -> Image? {
//        return generateSVGImage(data: data) ?? image(with: data, options: options)
//    }
//
//    func data(with image: Image, original: Data?) -> Data? {
//        return original
//    }
//}
//
//func generateSVGImage(data: Data, size: CGSize? = CGSize(width:250, height:250)) -> UIImage?{
//    let frame = CGRect(x: 0, y: 0, width: size!.width, height: size!.height)
//    if let svgString = String(data: data, encoding: .utf8){
//        let svgLayer = SVGLayer(layer: svgString)
//        svgLayer.frame = frame
//        return snapshotImage(for: svgLayer)
//    }
//    return nil
//}
//
//func snapshotImage(for layer: CALayer) -> UIImage? {
//    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
//    guard let context = UIGraphicsGetCurrentContext() else { return nil }
//    layer.render(in: context)
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return image
//}
