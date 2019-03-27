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
            
            translatesAutoresizingMaskIntoConstraints = false

//            superview?.translatesAutoresizingMaskIntoConstraints = true
            
//            print(#function + " x = \(center.x), y = \(center.y) || super view: x = \(String(describing: superview?.center.x)), y = \(String(describing: superview?.center.y))")
//            Print.m("Super view width and height / 2 ->> \((superview?.frame.width)! / 2) ->> \((superview?.frame.height)! / 2)")
            //self.center = (superview?.center)!
//            var halfWidth = frame.width / 2
//            var halfHeight = frame.height / 2
//            centerXAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
//            self.centerXAnchor.constraint(equalTo: (superview?.centerXAnchor)!).isActive = true
//            self.centerYAnchor.constraint(equalTo: (superview?.centerYAnchor)!).isActive = true
            
//            center.x = (superview?.center.x)!
//            center.y = (superview?.center.y)!
            superview?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            superview?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
//            superview?.addConstraints([
//                NSLayoutConstraint(item: superview!, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1.0, constant: 8),
//                NSLayoutConstraint(item: superview!, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .right, multiplier: 1.0, constant: 8)
//                ])
//            self.alignmentRect(forFrame: (superview?.frame)!)
        } else {
            print("superview is nil, method \(#function) don't working see extension \(#file)")
        }
    }
    
    func setCenterFromParentTrue() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = true
            
            self.center.x = (superview.frame.width / 2)// - (frame.width / 2)
            self.center.y = (superview.frame.height / 2)//- (frame.height / 2)
        }
    }
}
