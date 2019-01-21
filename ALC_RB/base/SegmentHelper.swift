//
//  SegmentHelper.swift
//  ALC_RB
//
//  Created by ayur on 18.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

/// Using with view container and segmented control
class SegmentHelper {
    
    var rootViewController: UIViewController?
    var rootViewContainer: UIView?
    
    init(_ root: UIViewController, _ view: UIView) {
        self.rootViewController = root
        self.rootViewContainer = view
    }
    
    func add(_ viewController: UIViewController) {
        rootViewController?.addChild(viewController)
        rootViewContainer?.addSubview(viewController.view)
        viewController.view.frame = (rootViewContainer?.bounds)!
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
