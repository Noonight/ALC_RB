//
//  TournamentDetailViewController.swift
//  ALC_RB
//
//  Created by user on 27.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD
struct LeagueDetailModel {
    var league = League()
    var leagueInfo = LILeagueInfo()

    init() { }
    
    init (_ league: League) {
        self.league = league
    }
}
fileprivate enum Segments: Int {
    case schedule = 0
    case teams = 1
    case players = 2
    
    static func instance(index: Int) -> Segments {
        switch index {
        case 0:
            return Segments.schedule
        case 1:
            return Segments.teams
        case 2:
            return Segments.players
        default:
            return Segments.schedule
        }
    }
}

class LeagueDetailViewController: UIViewController {
    
    @IBOutlet weak var announce_view: UIView!
    @IBOutlet weak var announce_height: NSLayoutConstraint!
    @IBOutlet weak var announce_label: UILabel!
    
    lazy var scheduleTable: ScheduleTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
        
//        viewController.leagueDetailModel.league = self.leagueDetailModel.league
//        viewController.leagueDetailModel.leagueInfo = self.leagueDetailModel.leagueInfo
        
        return viewController
    }()
    lazy var teamsTable: TeamsLeagueTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "TeamsLeagueTableViewController") as! TeamsLeagueTableViewController
        
//        viewController.leagueDetailModel = self.leagueDetailModel
        
        return viewController
    }()
    lazy var playersTable: PlayersLeagueDetailViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "PlayersLeagueDetailViewController") as! PlayersLeagueDetailViewController
        
//        viewController.leagueDetailModel = self.leagueDetailModel
        
        return viewController
    }()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mTitle: UILabel!
    
    var leagueModelItem: LeagueModelItem!
    var segmentHelper: SegmentHelper!
    private var viewModel: LeagueDetailViewModel!
    var hud: MBProgressHUD?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentHelper()
        setupViewModel()
        setupBinds()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        navigationController?.navigationBar.hideBorderLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.showBorderLine()
    }
}

// MARK: - SETUP

extension LeagueDetailViewController {
    
    func setupView() {
//        self.segmentHelper.add(scheduleTable)
        self.mTitle.text = leagueModelItem.name
        stackView.addBackground(color: navigationController?.navigationBar.barTintColor ?? UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0))
    }
    
    func setupViewModel() {
        self.viewModel = LeagueDetailViewModel(dataManager: ApiRequests())
    }
    
    func setupBinds() {
        
        segmentControl
            .rx
            .selectedSegmentIndex
            .bind(to: self.rx.choosedSegment)
            .disposed(by: disposeBag)
        
    }
    
    func setupSegmentHelper() {
        self.segmentHelper = SegmentHelper(self, viewContainer)
    }
    
}

// MARK: REACTIVE

extension Reactive where Base: LeagueDetailViewController {
    
    internal var choosedSegment: Binder<Int> {
        return Binder(self.base) { vc, segmentIndex in
            let segment = Segments.instance(index: segmentIndex)
            vc.segmentHelper.removeAll()
            switch segment {
            case .schedule:
                vc.segmentHelper.add(vc.scheduleTable)
            case .teams:
                vc.segmentHelper.add(vc.teamsTable)
            case .players:
                vc.segmentHelper.add(vc.playersTable)
            }
        }
    }
    
    internal var isLoading: Binder<Bool> {
        return Binder(self.base) { vc, loading in
            if loading == true {
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
            guard let mError = error else { return }
            if vc.hud != nil {
                vc.hud?.setToFailureView(detailMessage: mError.localizedDescription, tap: {
                    
                })
            } else {
                vc.hud = vc.showFailureViewHUD(detailMessage: mError.localizedDescription, tap: {
                    
                })
            }
        }
    }
}

