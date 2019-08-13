//
//  UIAlertController + Extension.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func addAction(title: String, complection: @escaping ()->()) {
        let action = UIAlertAction(title: title, style: .default) { (action) in
            complection()
        }
        self.addAction(action)
    }
    
    func addDestructiveAction(title: String, complection: @escaping ()->()) {
        let action = UIAlertAction(title: title, style: .destructive) { (action) in
            complection()
        }
        self.addAction(action)
    }
    
    func addCancelAction(title: String, complection: @escaping ()->() = {}) {
        let action = UIAlertAction(title: title, style: .cancel) { (action) in
            complection()
        }
        self.addAction(action)
    }
}
