//
//  KingExtensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

public struct CroppingImageProcessorCustom: ImageProcessor {
    
    /// Identifier of the processor.
    /// - Note: See documentation of `ImageProcessor` protocol for more.
    public let identifier: String
    
    /// Target size of output image should be.
    public let size: CGSize
    
    /// Anchor point from which the output size should be calculate.
    /// The anchor point is consisted by two values between 0.0 and 1.0.
    /// It indicates a related point in current image.
    /// See `CroppingImageProcessor.init(size:anchor:)` for more.
    public let anchor: CGPoint
    
    /// Creates a `CroppingImageProcessor`.
    ///
    /// - Parameters:
    ///   - size: Target size of output image should be.
    ///   - anchor: The anchor point from which the size should be calculated.
    ///             Default is `CGPoint(x: 0.5, y: 0.5)`, which means the center of input image.
    /// - Note:
    ///   The anchor point is consisted by two values between 0.0 and 1.0.
    ///   It indicates a related point in current image, eg: (0.0, 0.0) for top-left
    ///   corner, (0.5, 0.5) for center and (1.0, 1.0) for bottom-right corner.
    ///   The `size` property of `CroppingImageProcessor` will be used along with
    ///   `anchor` to calculate a target rectangle in the size of image.
    ///
    ///   The target size will be automatically calculated with a reasonable behavior.
    ///   For example, when you have an image size of `CGSize(width: 100, height: 100)`,
    ///   and a target size of `CGSize(width: 20, height: 20)`:
    ///   - with a (0.0, 0.0) anchor (top-left), the crop rect will be `{0, 0, 20, 20}`;
    ///   - with a (0.5, 0.5) anchor (center), it will be `{40, 40, 20, 20}`
    ///   - while with a (1.0, 1.0) anchor (bottom-right), it will be `{80, 80, 20, 20}`
    public init(size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
        self.size = size
        self.anchor = anchor
        self.identifier = "com.onevcat.Kingfisher.CroppingImageProcessorCustom(\(size)_\(anchor))"
    }
    
    /// Processes the input `ImageProcessItem` with this processor.
    ///
    /// - Parameters:
    ///   - item: Input item which will be processed by `self`.
    ///   - options: Options when processing the item.
    /// - Returns: The processed image.
    ///
    /// - Note: See documentation of `ImageProcessor` protocol for more.
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
