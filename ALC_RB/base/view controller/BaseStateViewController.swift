//
//  BaseStateViewController.swift
//  ALC_RB
//
//  Created by ayur on 21.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

enum BaseState : Equatable {
    case loading
    case error(message: String)
    case empty
    case normal
    
    static func ==(lhs: BaseState, rhs: BaseState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .error(messageLeft), let .error(messageRight)):
            return false
        case (.empty, .empty):
            return true
        case (.normal, .normal):
            return true
        default:
            return false
        }
    }
}

protocol BaseStateActions {
    
    func setState(state: BaseState)
    
}

class BaseStateViewController : UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    let emptyView = EmptyViewNew()
    var backgroundView: UIView?
    
    var lastState = BaseState.loading
    var state = BaseState.loading
    
    var emptyMessage: String = "Здесь будет контент. Возможно забыли настроить сообщение!"
    
    func setEmptyMessage(message new: String) {
        self.emptyMessage = new
    }
    
}

extension BaseStateViewController : BaseStateActions {
    func setState(state: BaseState) {
        if self.state != state {
            switch state {
            case .normal:
                hideLoading()
                hideEmptyView()
                self.state = .normal
                self.lastState = .normal
            case .loading:
                hideEmptyView() // background view first clear
                showLoading() // after add new background view
                self.state = .loading
                self.lastState = .loading
            case .error(let message):
                showAlert(message: message)
                self.state = .error(message: message)
            case .empty:
                hideLoading()
                showEmptyView()
                self.state = .empty
                self.lastState = .empty
            }
        }
        
    }
}

extension BaseStateViewController : EmptyProtocol {
    func showEmptyView() {
        backgroundView = UIView()
        
        backgroundView?.frame = view.frame
        backgroundView?.backgroundColor = .white
        
        backgroundView?.addSubview(emptyView)
        view.addSubview(backgroundView!)
        
        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
        
        emptyView.setText(text: emptyMessage)
        
        emptyView.setCenterFromParentTrue()
        emptyView.containerView.setCenterFromParentTrue()
        
    }
    
    func hideEmptyView() {
        if let backgroundView = backgroundView {
//            backgroundView.removeFromSuperview()
            UIView.animate(withDuration: 0.2) {
                backgroundView.removeFromSuperview()
            }
        }
    }
}

extension BaseStateViewController : ActivityIndicatorProtocol {
    func showLoading() {
        backgroundView = UIView()
        
        backgroundView?.frame = view.frame
        backgroundView?.backgroundColor = .white
        
        backgroundView?.addSubview(activityIndicator)
        view.addSubview(backgroundView!)
        
        backgroundView?.translatesAutoresizingMaskIntoConstraints = true
        
        activityIndicator.frame = view.frame
        activityIndicator.backgroundColor = .white
        
//        view.addSubview(activityIndicator)
//        view.bringSubviewToFront(activityIndicator)
        
        activityIndicator.setCenterFromParent()
        
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        
        if let backgroundView = backgroundView {
            UIView.animate(withDuration: 0.2) {
                backgroundView.removeFromSuperview()
            }
        }
//        activityIndicator.removeFromSuperview()
    }
}
