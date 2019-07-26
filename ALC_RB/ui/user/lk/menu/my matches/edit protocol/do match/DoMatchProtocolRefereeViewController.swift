//
//  DoMatchProtocolRefereeViewController.swift
//  ALC_RB
//
//  Created by ayur on 26.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class DoMatchProtocolRefereeViewController: UIViewController {
    enum Texts {
        static let FIRST_TIME   = "1 тайм"
        static let SECOND_TIME  = "2 тайм"
        static let MORE_TIME    = "Дополнительное время"
        static let PENALTY      = "Серия пенальти"
    }
    enum Segues {
        static let REFEREES     = "segue_edit_referees_do_protocol"
    }
    
    // MARK: Var & Let
    
    let presenter = DoMatchProtocolRefereePresenter()
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPresenter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension DoMatchProtocolRefereeViewController {
    func setupPresenter() {
        self.initPresenter()
    }
}

// MARK: ACTIONS

extension DoMatchProtocolRefereeViewController {
    
}

// MARK: PRESENTER

extension DoMatchProtocolRefereeViewController: DoMatchProtocolRefereeView {
    func initPresenter() {
        self.presenter.attachView(view: self)
    }
    
    
}

// MARK: NAVIGATION

extension DoMatchProtocolRefereeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.REFEREES,
            let _ = segue.destination as? EditRefereesProtocolViewController
        {
//            destination.refereesController = self.refereesController
//            destination.viewModel?.comingMatch = self.match
        }
    }
}
