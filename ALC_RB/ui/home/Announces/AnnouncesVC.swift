//
//  AnnouncesVC.swift
//  ALC_RB
//
//  Created by ayur on 24.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import FloatingPanel
import MBProgressHUD
import RxSwift
import RxCocoa

final class AnnouncesVC: UIViewController {

    struct Text {
        static let NO_ANNOUNCES = "Новых объявлений не найдено"
    }
    
    @IBOutlet weak var announces_table: UITableView!
    @IBOutlet weak var visual_effect_view: UIVisualEffectView!
    @IBOutlet weak var header_view: UIView!
    @IBOutlet weak var loading_repeat_view: LoadingRepeatView!
    @IBOutlet weak var header_height: NSLayoutConstraint!
    @IBOutlet weak var text_with_image_label: ImageWithTextInCenter!
    
    private lazy var shadowLayer: CAShapeLayer = CAShapeLayer()
    
    var announcesViewModel: AnnouncesViewModel!
    var hud: MBProgressHUD?
    private let disposeBag = DisposeBag()
    
    private static let HEADER_FULL_HEIGHT = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAnnouncesViewModel()
        self.setupLoadingRepeatCounter()
        self.setupAnnouncesTable()
        setupBinds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        announcesViewModel.fetch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) {
        } else {
            // Exmaple: Add rounding corners on iOS 10
            visual_effect_view.layer.cornerRadius = 9.0
            visual_effect_view.clipsToBounds = true
            
            // Exmaple: Add shadow manually on iOS 10
            view.layer.insertSublayer(shadowLayer, at: 0)
            let rect = visual_effect_view.frame
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 9.0, height: 9.0))
            shadowLayer.frame = visual_effect_view.frame
            shadowLayer.shadowPath = path.cgPath
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3.0
        }
    }
}

// MARK: EXTENSIONS



// MARK: SETUP

private extension AnnouncesVC {
    
    func setupLoadingRepeatCounter() {
        self.text_with_image_label.backColor = .orange
        self.text_with_image_label.textColor = .white
    }
    
//    func setupLoadingRepeatView() {
//        self.loading_repeat_view.configureAction {
//            self.announcesViewModel.fetch()
//        }
//    }
    
    func setupAnnouncesViewModel() {
        self.announcesViewModel = AnnouncesViewModel(newDataManager: ApiRequests())
    }
    
    func setupAnnouncesTable() {
        let cellNib = UINib(nibName: "HomeAnonunceTableViewCell", bundle: Bundle.main)

        self.announces_table.register(cellNib, forCellReuseIdentifier: HomeAnonunceTableViewCell.ID)
    }
    
    func setupBinds() {
        
        announcesViewModel
            .items
            .bind(to: announces_table.rx.items(cellIdentifier: HomeAnonunceTableViewCell.ID, cellType: HomeAnonunceTableViewCell.self)) { (row, announce, cell) in
                cell.announceModelItem = announce
            }
            .disposed(by: disposeBag)
        
        announcesViewModel
            .items
            .map({ $0.count })
            .bind(to: self.rx.countOfItems)
            .disposed(by: disposeBag)
        
        announcesViewModel
            .items
            .map({ $0.count == 0})
            .bind(to: self.rx.isEmpty)
            .disposed(by: disposeBag)
        
        announcesViewModel
            .loading
            .bind(to: self.rx.isLoading)
            .disposed(by: disposeBag)
        
        announcesViewModel
            .error
            .bind(to: self.rx.error)
            .disposed(by: disposeBag)
        
        loading_repeat_view.btn
            .rx
            .tap
            .bind(onNext: {
                self.announcesViewModel.fetch()
            })
            .disposed(by: disposeBag)
        
        
    }
}

// MARK: HELPERS

extension AnnouncesVC {
    
    func showEmptyViewGoToChooser() {
        if self.hud != nil {
            self.hud?.setToEmptyView(message: Constants.Texts.NO_STARRED_TOURNEYS, detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS, tap: {
                self.showTourneyPicker()
            })
        } else {
            self.hud = showEmptyViewHUD(addTo: self.announces_table, message: Constants.Texts.NO_STARRED_TOURNEYS, detailMessage: Constants.Texts.GO_TO_CHOOSE_TOURNEYS, tap: {
                self.showTourneyPicker()
            })
        }
    }
    
}

// MARK: NAVIGATION

extension AnnouncesVC {
    
    func showTourneyPicker() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TournamentSearchVC") as! TournamentSearchVC
        self.navigationController?.show(newViewController, sender: self)
    }
    
}

// MARK: REACTIVE

extension Reactive where Base: AnnouncesVC {

    internal var isLoading: Binder<Bool> {
        return Binder(self.base) { vc, loading in
            vc.text_with_image_label.isHidden = loading
            if loading == true {
                vc.loading_repeat_view.isLoadingComplete = false
                if vc.hud != nil {
                    vc.hud?.setToLoadingView()
                } else {
                    vc.hud = vc.showLoadingViewHUD(addTo: vc.announces_table)
                }
            } else {
                vc.loading_repeat_view.isLoadingComplete = true
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
    internal var error: Binder<Error?> {
        return Binder(self.base) { vc, error in
            if error != nil {
                if vc.hud != nil {
                    vc.hud?.setToFailureView(detailMessage: error!.localizedDescription, tap: {
                        vc.announcesViewModel.fetch()
                    })
                } else {
                    vc.hud = vc.showFailureViewHUD(addTo: vc.announces_table, detailMessage: error!.localizedDescription, tap: {
                        vc.announcesViewModel.fetch()
                    })
                }
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
            
        }
    }
    
    internal var countOfItems: Binder<Int> {
        return Binder(self.base) { vc, count in
            vc.text_with_image_label.text = String(count)
        }
    }
    
    internal var isEmpty: Binder<Bool> {
        return Binder(self.base) { vc, empty in
            vc.text_with_image_label.isHidden = empty
            if empty == true {
                vc.showEmptyViewGoToChooser()
            } else {
                vc.hud?.hide(animated: false)
                vc.hud = nil
            }
        }
    }
}
