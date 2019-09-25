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
    
    private lazy var all : HomeAllVC = HomeAllVC()
    private lazy var newsTable: NewsAnnounceTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "NewsTableViewController") as! NewsAnnounceTableViewController
        
        //self.add(childVC: viewController)
        
        return viewController
    }()
    private lazy var gamesTable: UpcomingGamesTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "UpcomingGamesTableViewController") as! UpcomingGamesTableViewController
        
        //self.add(childVC: viewController)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        fpc.surfaceView.backgroundColor = .clear
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
//            segmentHelper?.removeAll()
            segmentHelper?.removeAllExcept(vc: fpc)
            segmentHelper?.add(all)
        case 1: // My tournaments
//            segmentHelper?.removeAll()
            segmentHelper?.removeAllExcept(vc: fpc)
//            segmentHelper?.add(myTournaments)
            Print.m("hello")
        case 2: // News
//            segmentHelper?.removeAll()
            segmentHelper?.removeAllExcept(vc: fpc)
            segmentHelper?.add(newsTable)
        case 3: // Schedule
//            segmentHelper?.removeAll()
            segmentHelper?.removeAllExcept(vc: fpc)
//            segmentHelper?.add(schedule)
            Print.m("hello")
        default:
            break
        }
    }
}

// MARK: CELL ACTIONS

extension HomeViewController: CellActions {
    func onCellSelected(model: CellModel) {
        switch model {
        case is AnnounceElement:
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
            fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
            fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
            return SearchPanelLandscapeLayout()
        default:
            fpc.surfaceView.borderWidth = 0.0
            fpc.surfaceView.borderColor = nil
            return nil
        }
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        let y = vc.surfaceView.frame.origin.y
        let tipY = vc.originYOfSurface(for: .tip)
        if y > tipY - 44.0 {
            let progress = max(0.0, min((tipY  - y) / 44.0, 1.0))
            self.announcesVC.announces_table.alpha = progress
//            self.searchVC.tableView.alpha = progress
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.position == .full {
            Print.m("floating Panel Will Begin Dragging")
//            announcesVC
//            searchVC.searchBar.showsCancelButton = false
//            searchVC.searchBar.resignFirstResponder()
        }
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition != .full {
            Print.m("floating Panel Did End Dragging")
//            searchVC.hideHeader()
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        if targetPosition == .tip {
                            self.announcesVC.announces_table.alpha = 0.0
                        } else {
                            self.announcesVC.announces_table.alpha = 1.0
                        }
        }, completion: nil)
    }
    
}

// MARK: FloatingPanelLayout

public class SearchPanelLandscapeLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
//        return .tip
        return FloatingPanelPosition.hidden
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full/*, .tip*/]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
//        case .tip: return 69.0
        default: return nil
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        } else {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        }
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}
