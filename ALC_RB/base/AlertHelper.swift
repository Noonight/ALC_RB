//
//  AlertHelper.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for action in actions {
                alert.addAction(action)
            }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRefreshAlert(title: String = "Ошибка!", message: String, refresh_closure: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Перезагрузить", style: .default, handler: { (action) in
            refresh_closure()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
