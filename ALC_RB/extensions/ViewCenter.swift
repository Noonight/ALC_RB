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
            self.center = (superview?.center)!
            self.centerXAnchor.constraint(equalTo: (superview?.centerXAnchor)!)
            self.centerYAnchor.constraint(equalTo: (superview?.centerYAnchor)!)
        } else {
            print("superview is nil, method \(#function) don't working see extension \(#file)")
        }
    }
}
