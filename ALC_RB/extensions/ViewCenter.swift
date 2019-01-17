//
//  ViewCenter.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension UIView {
    func setCenterFromParent() {
        if (superview != nil) {
            print(#function + " x = \(center.x), y = \(center.y) || parent: x = \(superview?.center.x), y = \(superview?.center.y)")
            //self.center = (superview?.center)!
//            var halfWidth = frame.width / 2
//            var halfHeight = frame.height / 2
//            centerXAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
//            self.centerXAnchor.constraint(equalTo: (superview?.centerXAnchor)!).isActive = true
//            self.centerYAnchor.constraint(equalTo: (superview?.centerYAnchor)!).isActive = true
            
            center.x = (superview?.center.x)!
            center.y = (superview?.center.y)!
//            self.alignmentRect(forFrame: (superview?.frame)!)
        } else {
            print("superview is nil, method \(#function) don't working see extension \(#file)")
        }
    }
}
