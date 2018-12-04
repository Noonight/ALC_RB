//
//  MvpPresenter.swift
//  ALC_RB
//
//  Created by user on 21.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

class MvpPresenter<T: MvpView> {
    
    private var view: T?

    init() {
    }
    
    func attachView(view: T) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func getView() -> T {
        return view!
    }
    
}
