//
//  UserTourneysVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate enum Segments: Int {
    case inside = 0
    case my = 1
    
    static func instance(index: Int) -> Segments {
        switch index {
        case 0:
            return Segments.inside
        case 1:
            return Segments.my
        default:
            return Segments.inside
        }
    }
}

class UserTourneysVC: UIViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var segmentHelper: SegmentHelper!
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentHelper()
        setupBinds()
    }

}

// MARK: SETUP

extension UserTourneysVC {
    
    func setupBinds() {
        
        segmentController
            .rx
            .selectedSegmentIndex
            .bind(to: self.rx.choosedSegment)
            .disposed(by: bag)
        
    }
    
    func setupSegmentHelper() {
        self.segmentHelper = SegmentHelper(self, containerView)
    }
    
}

extension Reactive where Base: UserTourneysVC {
    
    internal var choosedSegment: Binder<Int> {
            return Binder(self.base) { vc, segmentIndex in
                let segment = Segments.instance(index: segmentIndex)
                vc.segmentHelper.removeAll()
                switch segment {
                case .inside:
    //                vc.segmentHelper.add(vc.scheduleTable)
                    let nVc = InsideTourneysVC.getInstance()
//                    nVc.viewModel.leagueDetailModel = vc.viewModel.leagueDetailModel
                    vc.segmentHelper.add(nVc)
                case .my:
                    let nVc = MyTourneysVC.getInstance()
//    //                nVc.viewModel.leagueDetailModel = vc.viewModel.leagueDetailModel
//                    nVc.leagueDetailModel = vc.viewModel.leagueDetailModel.value
                    vc.segmentHelper.add(nVc)
                }
            }
        }
    
}
