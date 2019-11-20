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
    
    let choosedLeague = PublishSubject<League>()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        setupBinds()
        setupNavBar()
        
        viewModel.fetch()
    }
}

// MARK: - SETUP

extension ChooseTourneyLeagueVC {
    
    func setupNavBar() {
        modalPresentationCapturesStatusBarAppearance = true
        navBar.titleLabel.text = "Выберите Лигу"
        //        navBar.leftButton.setTitle("Cancel", for: .normal)
        //        navBar.leftButton.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        
        view.addSubview(navBar)
        
        topConstraint.constant = navBar.height
    }
    
    func setupTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.register(UINib(nibName: "ChooseRegionCell", bundle: Bundle.main), forCellReuseIdentifier: ChooseRegionCell.ID)
    }
    
    func setupViewModel() {
        self.viewModel = ChooseTourneyLeagueVM(tourneyApi: TourneyApi())
    }
    
    func setupBinds() {
        
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
        
        self.viewModel
            .findedLeagues
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(cellIdentifier: ChooseRegionCell.ID, cellType: ChooseRegionCell.self)) { row, region, cell in
                cell.region = region
            }
            .disposed(by: bag)
        
        self.tableView.rx
            .itemSelected
            .subscribe({ indexPath in
                guard let index = indexPath.element else { return }
                let cell = self.tableView.cellForRow(at: index) as! ChooseRegionCell
                
                self.callBack?.complete(region: cell.region)
                self.choosedRegion.onNext(cell.region)
                self.choosedRegion.onCompleted()
                
                self.tableView.deselectRow(at: index, animated: true)
                
                self.close()
            })
            .disposed(by: bag)
        
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

extension ChooseTourneyLeagueVC {
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closePressed(_ sender: UIButton) {
        Print.m("close this view")
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
