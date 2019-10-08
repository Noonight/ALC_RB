//
//  UIScrollView + Extensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 08/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
