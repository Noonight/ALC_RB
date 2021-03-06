//
//  HomeViewController.swift
//  ALC_RB
//
//  Created by user on 21.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import FloatingPanel

class HomeViewController: UIViewController {
    
    private lazy var all : HomeAllVC = {
        let vc = HomeAllVC()
        vc.announcesReloadCallBack = announcesVC
        
        return vc
    }()
    private lazy var newsTable: NewsAllTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsAllTableViewController") as! NewsAllTableViewController
        
        viewController.announcesReloadCallBack = announcesVC
        
        return viewController
    }()
    private lazy var gamesTable: UpcomingGamesTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "UpcomingGamesTableViewController") as! UpcomingGamesTableViewController
        
        return viewController
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var announces_table: UITableView!
    @IBOutlet weak var headerOfAnnounces_view: UIView!
    @IBOutlet weak var announces_table_height: NSLayoutConstraint!
    
    private var segmentHelper: SegmentHelper?
    private var fpc: FloatingPanelController!
    private var announcesVC: AnnouncesVC!
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSegmentHelper()
        self.setupFPC()
        firstInit()
        
//        let  matchApi = MatchApi()
//        matchApi.get_upcomingMatches(resultMy: { result in
//            switch result {
//            case .success(let matches):
//                Print.m(matches)
//            case .message(let message):
//                Print.m(message.message)
//
//            case .failure(.error(let error)):
//                Print.m(error)
//
//            case .failure(.notExpectedData):
//                Print.m("not expected data")
//            }
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        segmentedControl.setTitle("Всё", forSegmentAt: 0)
        segmentedControl.setTitle("Новости", forSegmentAt: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fpc.addPanel(toParent: self, animated: true)
    }
    
    private func firstInit() {
        segmentHelper?.add(all)
    }
    
}

// MARK: EXTENSIONS



// MARK: SETUP

extension HomeViewController {
    
    func setupFPC() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        // Initialize FloatingPanelController and add the view
//        fpc.surfaceView.backgroundColor = .clear
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 9.0
        } else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.surfaceView.shadowHidden = false
        
        announcesVC = AnnouncesVC()
        
        // Set a content view controller
        fpc.set(contentViewController: announcesVC)
        fpc.track(scrollView: announcesVC.announces_table)
    }
    
    func setupSegmentHelper() {
        self.segmentHelper = SegmentHelper(self, viewContainer)
    }
}

// MARK: ACTIONS

extension HomeViewController {
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segmentHelper?.removeAllExcept(vc: fpc)
            segmentHelper?.add(all)
        case 1: // News
            segmentHelper?.removeAllExcept(vc: fpc)
            segmentHelper?.add(newsTable)
        case 2: // Schedule
            segmentHelper?.removeAllExcept(vc: fpc)
            segmentHelper?.add(gamesTable)
        default:
            break
        }
    }
}

// MARK: CELL ACTIONS

extension HomeViewController: TableActions {
    func onCellDeselected(model: CellModel) {
        
    }
    
    func onCellSelected(model: CellModel) {
        switch model {
        case is Announce:
            Print.m("the model of element is AnnounceElement")
            return
        default:
            return
        }
    }
}

// MARK: FloatingPanelControllerDelegate

extension HomeViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        switch newCollection.verticalSizeClass {
        case .compact:
//            Print.m("compact")
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return MyPanelLayout()
        case .regular:
//            Print.m("regular")
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = nil
            return MyPanelLayout()
        case .unspecified:
//            Print.m("unspecified")
            fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return MyPanelLayout()
        default:
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = nil
            return nil
        }
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
//        let y = vc.surfaceView.frame.origin.y
//        let tipY = vc.originYOfSurface(for: .tip)
//        if y > tipY - 44.0 {
//            let progress = max(0.0, min((tipY  - y) / 44.0, 1.0))
//            self.announcesVC.announces_table.alpha = progress
//        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) { }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        if targetPosition == .tip {
//                            self.announcesVC.announces_table.alpha = 0.0
                        } else {
//                            self.announcesVC.announces_table.alpha = 1.0
                        }
        }, completion: nil)
    }
    
}

// MARK: FloatingPanelLayout

public class MyPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip, .full]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .tip: return 65.0
        case .full: return 16
        default: return nil
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            surfaceView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}
