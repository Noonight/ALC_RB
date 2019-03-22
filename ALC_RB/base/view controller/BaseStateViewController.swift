//
//  BaseStateViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

enum BaseState {
    case loading
    case error(message: String)
    case empty(message: String)
    case normal
}

protocol BaseStateActions {
    
    func setState(state: BaseState)
    
}

class BaseStateViewController : UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    let emptyView = EmptyView()
    var backgroundView: UIView?
    
    
}

extension BaseStateViewController : BaseStateActions {
    func setState(state: BaseState) {
        switch state {
        case .normal:
            Print.m("Normal state")
        case .loading:
            view.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
            view.bringSubviewToFront(activityIndicator)
            Print.m("Loading state")
        case .error(let message):
            Print.m("Error state with message ->> \(message)")
        case .empty(let message):
            Print.m("Empty state with message ->> \(message)")
        }
    }
}
