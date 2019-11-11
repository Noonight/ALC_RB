//
//  PlayersVC.swift
//  ALC_RB
//
//  Created by mac on 08.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SPStorkController

final class PlayersVC: UIViewController {
    
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var chooseRegion: ChooseRegionVC = {
        let chooseRegion = ChooseRegionVC()
        
    }()
    
    private var viewModel: PlayersViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        setupBinds()
        
        viewModel.fetch()
    }
    
}

// MARK: - SETUP

extension PlayersVC {
    
    func setupViewModel() {
        self.viewModel = PlayersViewModel(personApi: PersonApi())
    }
    
    func setupTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    func setupBinds() {
        
        
        
        self.viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.tableView.rx.loading)
            .disposed(by: bag)
        
        self.viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.tableView.rx.error)
            .disposed(by: bag)
        
//        self.viewModel
//            .message
//            .asDriver(onErrorJustReturn: SingleLineMessage(message: "Driver fail"))
//            .drive(self.tableView.rx.message)
//            .disposed(by: bag)
    }
    
}

// MARK: - ACTIONS

extension PlayersVC {
    
    
    
}

// MARK: - SPSTORK DELEGATE

extension PlayersVC: SPStorkControllerDelegate {
    func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }
    
    func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
}

// MARK: - NAVIGATION

extension PlayersVC {
    
    func showRegion() {
        let modalVC = ChooseRegionVC(nibName: "ChooseRegionVC", bundle: nil)
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.storkDelegate = self
        transitionDelegate.confirmDelegate = modalVC
//        transitionDelegate.cornerRadius = -2
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.tapAroundToDismissEnabled = true
        transitionDelegate.showIndicator = true
//        transitionDelegate.showCloseButton = true
        //        transitionDelegate.customHeight = self.view.frame.height - 80
        modalVC.transitioningDelegate = transitionDelegate
        modalVC.modalPresentationStyle = .custom
        self.present(modalVC, animated: true, completion: nil)
    }
    
}
