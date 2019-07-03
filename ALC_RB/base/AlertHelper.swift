//
//  AlertHelper.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // default title is "Error"
    func showAlert(title: String = "Ошибка", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertOkCancel(title: String, message: String, ok: @escaping ()->(), cancel: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { alert in
            cancel()
        }))
        alert.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: { alert in
            ok()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        if alert.actions.count == 0 {
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, closure: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { alert in
            closure()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRefreshAlert(title: String = "Ошибка!", message: String, refresh_closure: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Перезагрузить", style: .destructive, handler: { (action) in
            refresh_closure()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showRepeatAlert(title: String = "Ошибка!", message: String, repeat_closure: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Повторить", style: .destructive, handler: { (action) in
            repeat_closure()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
