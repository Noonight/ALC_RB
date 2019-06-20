//
//  AlertHelper.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Перезагрузить", style: .default, handler: { (action) in
//            self.presenter.getUpcomingGames()
//        }))
        self.present(alert, animated: true, completion: nil)
    }
}
