//
//  ViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 22.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    
    internal var loading: Binder<Bool> {
        return Binder(self.base) { vc, isLoading in
            if isLoading == true {
                if vc.hud != nil {
                    vc.hud?.setToLoadingView()
                } else {
                    vc.hud = vc.showLoadingViewHUD()
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
    internal var error: Binder<Error?> {
        return Binder(self.base) { vc, error in
            if error != nil {
                if vc.hud != nil {
                    vc.hud?.setToFailureView(message: "", detailMessage: error?.localizedDescription, tap: {
                        vc.errorAction?()
                    })
                } else {
                    vc.hud = vc.showFailureViewHUD(message: "", detailMessage: error?.localizedDescription, tap: {
                        vc.errorAction?()
                    })
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
//    internal var message: Binder<SingleLineMessage> {
//        return Binder(self.base) { vc, message in
//            vc.showAlert(title: Constants.Texts.MESSAGE, message: message.message)
//        }
//    }
    
    internal var message: Binder<SingleLineMessage?> {
        return Binder(self.base) { vc, message in
            if let mMessage = message {
                vc.showAlert(title: Constants.Texts.MESSAGE, message: mMessage.message)
            }
        }
    }
    
    internal var empty: Binder<Bool> {
        return Binder(self.base) { vc, isEmpty in
            if isEmpty == true {
                if vc.hud != nil {
                    vc.hud?.setToEmptyView(tap: {
                        vc.emptyAction?()
                    })
                } else {
                    vc.hud = vc.showEmptyViewHUD {
                        vc.emptyAction?()
                    }
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
}

extension Reactive where Base: UIView {
    
    internal var loading: Binder<Bool> {
        return Binder(self.base) { vc, isLoading in
            if isLoading == true {
                if vc.hud != nil {
                    vc.hud?.setToLoadingView()
                } else {
                    vc.hud = vc.showLoadingViewHUD()
                }
            } else {
                vc.hideHUD()
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
    
    internal var error: Binder<Error?> {
        return Binder(self.base) { vc, error in
            if error != nil {
                if vc.hud != nil {
                    vc.hud?.setToFailureView(message: "", detailMessage: error?.localizedDescription, tap: {
                        vc.errorAction?()
                    })
                } else {
                    vc.hud = vc.showFailureViewHUD(message: "", detailMessage: error?.localizedDescription, tap: {
                        vc.errorAction?()
                    })
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
    internal var empty: Binder<Bool> {
        return Binder(self.base) { vc, isEmpty in
            if isEmpty == true {
                if vc.hud != nil {
                    vc.hud?.setToEmptyView(tap: {
                        vc.emptyAction?()
                    })
                } else {
                    vc.hud = vc.showEmptyViewHUD {
                        vc.emptyAction?()
                    }
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
}

