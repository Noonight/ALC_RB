//
//  NavigationBar.swift
//  ALC_RB
//
//  Created by ayur on 12.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func showBorderLine() {
        findBorderLine().isHidden = false
    }
    
    func hideBorderLine() {
        findBorderLine().isHidden = true
    }
    
    private func findBorderLine() -> UIImageView! {
        return self.subviews
            .flatMap { $0.subviews }
            .compactMap { $0 as? UIImageView }
            .filter { $0.bounds.size.width == self.bounds.size.width }
            .filter { $0.bounds.size.height <= 2 }
            .first
    }
    
}
