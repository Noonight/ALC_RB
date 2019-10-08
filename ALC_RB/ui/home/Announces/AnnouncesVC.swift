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
    
    private var announcesTable: HomeAnnouncesTable!
    private var announcesPresenter: AnnouncesPresenter!
    
    private static let HEADER_FULL_HEIGHT = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAnnouncesPresenter()
        self.setupAnnouncesTable()
        self.setupLoadingRepeatView()
        
        self.setupAnnouncesDS()
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
    
    func setupLoadingRepeatView() {
        self.loading_repeat_view.configureAction {
            self.repeatHelper()
        }
    }
    
    func setupAnnouncesPresenter() {
        self.announcesPresenter = AnnouncesPresenter(dataManager: ApiRequests())
    }
    
    func setupAnnouncesTable() {
        self.announcesTable = HomeAnnouncesTable(actions: self)
        self.announces_table.dataSource = self.announcesTable
        self.announces_table.delegate = self.announcesTable
        self.announces_table.register(self.announcesTable.cellNib, forCellReuseIdentifier: HomeAnonunceTableViewCell.ID)
    }
    
    func setupAnnouncesDS() {
        let hud = self.showLoadingViewHUD(addTo: self.announces_table)
   
        self.announces_table.turnOffScroll()
        self.announces_table.hideSeparator()
        
        self.loading_repeat_view.isLoadingComplete = false
        
        self.announcesPresenter.fetchAnnounces(
            success: { announces_r in
                self.fSuccess(hud: hud, announces: announces_r)
        }, r_message: { message in
            self.fMessage(hud: hud, message: message)
        }, all_failure: { error in
            Print.m(error)
            self.fAllFailure(hud: hud, error: error)
        }, server_failure: { error in
            Print.m(error)
            self.fServerFailure(hud: hud, error: error)
        }, local_failure: { error in
            Print.m(error)
            self.fLocalFailure(hud: hud, error: error)
        })
    }
}

// MARK: ACITONS

extension AnnouncesVC: CellActions {
    func onCellSelected(model: CellModel) {
        if model is Announce { }
    }
}

// MARK: STATE

extension AnnouncesVC {
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.view.layoutSubviews()
        
        if UIDevice.current.orientation.isLandscape
        {
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
        else
        {
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
        }
    }
}

// MARK: HELPERS

extension AnnouncesVC {
    
    func showCounter() {
        self.text_with_image_label.isHidden = false
        self.text_with_image_label.text = String(self.announcesTable.dataSource.count)
        self.text_with_image_label.backColor = .orange
        self.text_with_image_label.textColor = .white
    }
    
    func hideCounter() {
        self.text_with_image_label.isHidden = true
    }
    
    func repeatHelper() {
        self.setupAnnouncesDS()
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.25) {
            self.header_height.constant = CGFloat(AnnouncesVC.HEADER_FULL_HEIGHT)
        }
    }
    
    func hideHeader() {
        UIView.animate(withDuration: 0.25) {
            self.header_height.constant = 0
        }
    }
    
    func fSuccess(hud: MBProgressHUD? = nil, announces: [Announce]) {
        hud?.hide(animated: true)
        
        self.announces_table.turnOnScroll()
        self.announces_table.showSeparator()
        
        self.loading_repeat_view.isLoadingComplete = true
        
        self.announcesTable.dataSource = announces
        self.announces_table.reloadData()
        
        self.showCounter()
    }
    
    func fMessage(hud: MBProgressHUD? = nil, message: SingleLineMessage) {
        self.loading_repeat_view.isLoadingComplete = true
        self.hideCounter()
        hud?.setToButtonHUD(message: message.message, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fAllFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        self.hideCounter()
        hud?.setToButtonHUD(message: Constants.Texts.UNDEFINED_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fServerFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        self.hideCounter()
        hud?.setToButtonHUD(message: Constants.Texts.SERVER_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fLocalFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        self.hideCounter()
        hud?.setToButtonHUD(message: Constants.Texts.FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
}
