//
//  PenaltySeriesViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import SPStorkController

class ModalPenaltySeriesVC: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: EXTENSIONS

// MARK: SP STROKE CONTROLLER DELEGATE

extension ModalPenaltySeriesVC: SPStorkControllerConfirmDelegate {
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: "Need dismiss?", message: "It test confirm option for SPStorkController", preferredStyle: .actionSheet)
        alertController.addDestructiveAction(title: "Confirm", complection: {
            completion(true)
        })
        alertController.addCancelAction(title: "Cancel") {
            completion(false)
        }
        self.present(alertController, animated: true)

    }
    
    
}
