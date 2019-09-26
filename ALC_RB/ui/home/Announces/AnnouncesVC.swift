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

    @IBOutlet weak var announces_table: UITableView!
    @IBOutlet weak var visual_effect_view: UIVisualEffectView!
    @IBOutlet weak var header_view: UIView!
    @IBOutlet weak var loading_repeat_view: LoadingRepeatView!
    @IBOutlet weak var header_height: NSLayoutConstraint!
    
    private lazy var shadowLayer: CAShapeLayer = CAShapeLayer()
    
    private var announcesTable: HomeAnnouncesTable!
    private var announcesPresenter: AnnouncesPresenter!
    
    private static let HEADER_FULL_HEIGHT = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAnnouncesPresenter()
        self.setupAnnouncesTable()
        self.setupLoadingRepeatView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        let hud = self.announces_table.showLoadingViewHUD()
        self.loading_repeat_view.isLoadingComplete = false
        self.announcesPresenter.fetchAnnounces(
            success: { announces in
                self.fSuccess(hud: hud, announces: announces)
        }, r_message: { message in
            self.fMessage(hud: hud, message: message)
        }, all_failure: { error in
            self.fAllFailure(hud: hud, error: error)
        }, server_failure: { error in
            self.fServerFailure(hud: hud, error: error)
        }, local_failure: { error in
            self.fLocalFailure(hud: hud, error: error)
        })
    }
}

// MARK: ACITONS

extension AnnouncesVC: CellActions {
    func onCellSelected(model: CellModel) {
        if model is AnnounceElement {
            Print.m((model as! AnnounceElement).content)
        }
    }
}

// MARK: HELPERS

extension AnnouncesVC {
    
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
    
    func fSuccess(hud: MBProgressHUD? = nil, announces: Announce) {
        hud?.hide(animated: true)
        self.announcesTable.dataSource = announces.announces
        self.announces_table.reloadData()
        self.loading_repeat_view.isLoadingComplete = true
    }
    
    func fMessage(hud: MBProgressHUD? = nil, message: SingleLineMessage) {
        self.loading_repeat_view.isLoadingComplete = true
        hud?.setToButtonHUD(message: message.message, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fAllFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        hud?.setToButtonHUD(message: Constants.Texts.UNDEFINED_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fServerFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        hud?.setToButtonHUD(message: Constants.Texts.SERVER_FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
    func fLocalFailure(hud: MBProgressHUD? = nil, error: Error) {
        self.loading_repeat_view.isLoadingComplete = true
        hud?.setToButtonHUD(message: Constants.Texts.FAILURE, detailMessage: error.localizedDescription, btn: {
            self.setupAnnouncesDS()
        })
    }
    
}
