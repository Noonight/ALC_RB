//
//  Button Extensions.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 28/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitleAndColorWith(title: String, color: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
    }
}
