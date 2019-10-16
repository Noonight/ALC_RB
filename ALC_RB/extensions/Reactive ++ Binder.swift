//
//  Reactive ++ Binder.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 14.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base : UIScrollView {
    
//    public var isRefreshing: Binder<Bool> {
//        return Binder(self.base, binding: { (vc, active) in
//
//        })
//    }
//
//    public var isRefreshing: Driver
    
}

//extension Reactive where Base : UITableViewCell {
//
//    public var animateTap: Binder<Any> {
//        return Binder(self.base) { cell, _ in
//            cell.layoutIfNeeded()
//            UIView.animate(withDuration: 0.1, animations: {
//                cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
//            }) { completed in
//                if completed {
//                    UIView.animate(withDuration: 0.1) {
//                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                    }
//                } else {
//                    Print.m("completed = \(completed)")
//                }
//            }
//        }
//    }
//}
