//
//  CGSize Ext.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 22/07/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

extension CGSize {
    func half() -> CGSize {
        return CGSize(width: self.width / 2, height: self.height / 2)
    }
}
