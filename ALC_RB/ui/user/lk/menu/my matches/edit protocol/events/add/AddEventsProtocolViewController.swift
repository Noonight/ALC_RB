//
//  AddEventsProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 07.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class AddEventsProtocolViewController: BaseStateViewController {

    let presenter = AddEventsProtocolPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension AddEventsProtocolViewController : AddEventsProtocolView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
