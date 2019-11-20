//
//  ChooseTourneyLeagueVC.swift
//  ALC_RB
//
//  Created by mac on 20.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SPStorkController

protocol ChooseLeagueResult {
    func complete(league: League)
}

final class ChooseTourneyLeagueVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    let navBar = SPFakeBarView(style: .stork)
    
    var callBack: ChooseLeagueResult?
    private var viewModel: ChooseTourneyLeagueVM!
    private var tourneyTable: TourneyTable!
    
    private var chooseRegionVC: ChooseRegionVC!
    
    let choosedLeague = PublishSubject<League>()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        setupBinds()
        setupNavBar()
        setupRegionChooser()
        
        viewModel.fetch()
    }
}

// MARK: - SETUP

extension ChooseTourneyLeagueVC {
    
    func setupRegionChooser() {
        self.chooseRegionVC = ChooseRegionVC()
        chooseRegionVC.callBack = self
    }
    
    func setupNavBar() {
        modalPresentationCapturesStatusBarAppearance = true
        navBar.titleLabel.text = "Выберите Лигу"
                navBar.rightButton.setTitle("Отмена", for: .normal)
                navBar.rightButton.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        
        view.addSubview(navBar)
        
        topConstraint.constant = navBar.height
    }
    
    func setupTableView() {
//        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.allowsMultipleSelection = false
        tourneyTable = TourneyTable(cellActions: self)
        self.tableView.delegate = tourneyTable
        self.tableView.dataSource = tourneyTable
        self.tableView.register(UINib(nibName: "MyTourneyCell", bundle: Bundle.main), forCellReuseIdentifier: MyTourneyCell.ID)
    }
    
    func setupViewModel() {
        self.viewModel = ChooseTourneyLeagueVM(tourneyApi: TourneyApi())
    }
    
    func setupBinds() {
        
        regionBtn.rx
            .tap
            .bind {
                self.presentAsStork(self.chooseRegionVC, height: UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3))
            }.disposed(by: bag)
        
        searchBar.rx
            .cancelButtonClicked
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
                self.searchBar.text = nil
                self.view.endEditing(false)
                self.viewModel.query.accept(nil)
            })
            .disposed(by: bag)
        
        self.searchBar.rx
            .text
            .throttle(Constants.Values.searchThrottle, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe({ text in
                guard let mText = text.element else { return }
                if mText?.isEmpty ?? true {
                    self.viewModel.query.accept(nil)
                } else {
                    self.viewModel.query.accept(mText)
                }
                
                self.viewModel.fetch()
            })
            .disposed(by: bag)
        
//        self.chooseRegionVC
//            .choosedRegion
//            .observeOn(MainScheduler.instance)
//            .subscribe { regionElement in
//                guard let region = regionElement.element else { return }
//                Print.m(region)
//                self.viewModel.choosedRegion.accept(region)
//
//                self.viewModel.fetch()
//        }.disposed(by: bag)
        
        self.viewModel
            .findedLeagues
            .observeOn(MainScheduler.instance)
            .subscribe({ element in
                guard let items = element.element else { return }
                self.tourneyTable.dataSource = items
                self.tableView.reloadData()
            })
            .disposed(by: bag)
        
//        self.tableView.rx
//            .itemSelected
//            .subscribe({ indexPath in
//                guard let index = indexPath.element else { return }
//                let cell = self.tableView.cellForRow(at: index) as! ChooseRegionCell
//
//                self.callBack?.complete(region: cell.region)
//                self.choosedRegion.onNext(cell.region)
//                self.choosedRegion.onCompleted()
//
//                self.tableView.deselectRow(at: index, animated: true)
//
//                self.close()
//            })
//            .disposed(by: bag)
        
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
        
        self.viewModel
            .message
            .asDriver(onErrorJustReturn: SingleLineMessage(message: "Driver error"))
            .drive(self.rx.message)
            .disposed(by: bag)
    }
    
}

// MARK: - ACTION

extension ChooseTourneyLeagueVC: TableActions {
    
    func onCellSelected(model: CellModel) {
        if model is LeagueModelItem {
            Print.m(model as! LeagueModelItem)
            callBack?.complete(league: (model as! LeagueModelItem).league)
            choosedLeague.onNext((model as! LeagueModelItem).league)
            choosedLeague.onCompleted()
            
            close()
        }
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closePressed(_ sender: UIButton) {
        Print.m("close this view")
    }
    
}

// MARK: - ChooseRegionResult

extension ChooseTourneyLeagueVC: ChooseRegionResult {
    
    func complete(region: RegionMy) {
        Print.m("region is \(region)")
        self.regionBtn.setTitle(region.name, for: .normal)
        self.viewModel.choosedRegion.accept(region)
        
        self.viewModel.fetch()
    }
    
}

// MARK: - SP CONFIRM DELEGATE

extension ChooseTourneyLeagueVC: SPStorkControllerConfirmDelegate {
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

// MARK: - HELPER

extension ChooseTourneyLeagueVC {
    
    func showRegionChooser() {
        let transitionDelegate = SPStorkTransitioningDelegate()
        chooseRegionVC.transitioningDelegate = transitionDelegate
        chooseRegionVC.modalPresentationStyle = .formSheet
        chooseRegionVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(chooseRegionVC, animated: true, completion: nil)
    }
    
}

// MARK: OUT

extension ChooseTourneyLeagueVC {
    
    static func getTransitionInstance() -> ChooseTourneyLeagueVC {
        let chooseTourney = ChooseTourneyLeagueVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        chooseTourney.transitioningDelegate = transitionDelegate
        if #available(iOS 13.0, *) {
            chooseTourney.modalPresentationStyle = .automatic
        } else {
            chooseTourney.modalPresentationStyle = .custom
        }
        chooseTourney.modalPresentationCapturesStatusBarAppearance = true
        return chooseTourney
    }
    
}
