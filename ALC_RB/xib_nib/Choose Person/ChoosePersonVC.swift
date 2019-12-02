//
//  ChoosePersonVC.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SPStorkController

protocol ChoosePersonResult {
    func complete(person: Person)
    func complete(type: Referee.rType, person: Person)
}

extension ChoosePersonResult {
    func complete(person: Person) {}
    func complete(type: Referee.rType, person: Person) {}
}

class ChoosePersonVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private let navBar = SPFakeBarView(style: .stork)
    
    var callBack: ChoosePersonResult?
    var refereeType: Referee.rType?
    private var viewModel: ChoosePersonVM!
    private let bag = DisposeBag()
    
    private var chooseRegionVC: ChooseRegionVC!
    
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

// MARK: SETUP

extension ChoosePersonVC {
    
    func setupTableView() {
        tableView.separatorInset = .zero
        tableView.allowsMultipleSelection = false
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.register(UINib(nibName: "ChoosePersonCell", bundle: Bundle.main), forCellReuseIdentifier: ChoosePersonCell.ID)
    }
    
    func setupViewModel() {
        self.viewModel = ChoosePersonVM(personApi: PersonApi())
    }
    
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
        
        self.viewModel
            .findedPersons
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(cellIdentifier: ChoosePersonCell.ID, cellType: ChoosePersonCell.self)) { row, personModelItem, cell in
                cell.personModelItem = personModelItem
            }
            .disposed(by: bag)
        
        self.tableView.rx
            .itemSelected
            .subscribe({ indexPath in
                guard let index = indexPath.element else { return }
                let cell = self.tableView.cellForRow(at: index) as! ChoosePersonCell
                
                self.callBack?.complete(person: cell.personModelItem.person)
                if let refereeType = self.refereeType {
                    self.callBack?.complete(type: refereeType, person: cell.personModelItem.person)
                }
                
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

extension ChoosePersonVC {
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closePressed(_ sender: UIButton) {
        //        Print.m("close this view")
        self.close()
    }
    
}

// MARK: Choose Region Protocol

extension ChoosePersonVC: ChooseRegionResult {
    
    func complete(region: RegionMy) {
        self.regionBtn.setTitle(region.name, for: .normal)
        self.viewModel.choosedRegion.accept(region)
        
        self.viewModel.fetch()
    }
    
}

// MARK: - SP CONFIRM DELEGATE

extension ChoosePersonVC: SPStorkControllerConfirmDelegate {
    var needConfirm: Bool {
        return false
    }
    
    func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

// MARK: - HELPER

extension ChoosePersonVC {
    
    func showRegionChooser() {
        let transitionDelegate = SPStorkTransitioningDelegate()
        chooseRegionVC.transitioningDelegate = transitionDelegate
        chooseRegionVC.modalPresentationStyle = .formSheet
        chooseRegionVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(chooseRegionVC, animated: true, completion: nil)
    }
    
}

// MARK: OUT

extension ChoosePersonVC {
    
    static func getTransitionInstance() -> ChoosePersonVC {
        let chooseTourney = ChoosePersonVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        chooseTourney.transitioningDelegate = transitionDelegate
        chooseTourney.modalPresentationStyle = .custom
        chooseTourney.modalPresentationCapturesStatusBarAppearance = true
        return chooseTourney
    }
    
}
