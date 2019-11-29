//
//  CommandAddPlayerTableViewController.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 23/04/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TeamAddPlayersVC: UIViewController {
    private enum CellIdentifiers {
        static let list = "cell_command_add_player"
        static let loading = "cell_command_add_player_loading"
    }
    private enum Texts {
        static let playerInTeam = "Игрок уже получил приглашение в эту команду"
        static let PLAYER_IN_ANOTHER_TEAM = "В составе "
        static let PLAYER_INVITED_TO = "Приглашен в команду "
        static let IN_YOUR_TEAM = "В составе вашей команды"
        static let INVITED_INTO_YOUR_TEAM = "Приглашен в вашу команду"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var regionBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TeamAddPlayersViewModel = TeamAddPlayersViewModel(personApi: PersonApi(), inviteApi: InviteApi())
    private var teamTable: TeamAddPlayersTable!
    private let bag = DisposeBag()
    
    private var chooseRegionVC: ChooseRegionVC!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRegionChooser()
        self.setupTableView()
        self.bindViews()
        
//        self.setupSearchController()
//        self.prepareInfiniteScrollController()
        
        self.viewModel.fetch()
    }
}

// MARK: - SETUP

extension TeamAddPlayersVC {
    
    func bindViews() {
        
        viewModel
            .findedTeamPersons
            .observeOn(MainScheduler.instance)
            .subscribe { items in
                guard let models = items.element else { return }
                guard let persons = models else { return }
                self.teamTable.dataSource = persons
                self.tableView.reloadData()
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
        
        regionBtn.rx
            .tap
            .bind {
                self.presentAsStork(self.chooseRegionVC, height: UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3))
            }.disposed(by: bag)
        
        viewModel
            .error
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.error)
            .disposed(by: bag)
        
        viewModel
            .loading
            .asDriver(onErrorJustReturn: false)
            .drive(self.tableView.rx.loading)
            .disposed(by: bag)
        
        viewModel
            .message
            .asDriver(onErrorJustReturn: nil)
            .drive(self.rx.message)
            .disposed(by: bag)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск игроков"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
            // Fallback on earlier versions
        }
        definesPresentationContext = true
    }
    
    func setupRegionChooser() {
        self.chooseRegionVC = ChooseRegionVC()
        chooseRegionVC.callBack = self
    }
    
    func setupTableView() {
        teamTable = TeamAddPlayersTable(tableActions: self)
//        tableView.tableFooterView = UIView()
        tableView.delegate = teamTable
        tableView.dataSource = teamTable
    }
    
    func prepareInfiniteScrollController() {
        self.tableView.infiniteScrollIndicatorMargin = 40
        self.tableView.infiniteScrollTriggerOffset = 500
        self.tableView.addInfiniteScroll { tableView in
            Print.m("infinite scroll trigered")
        }
    }
}

// MARK: - ACTIONS

extension TeamAddPlayersVC: TeamAddTableActions {
    
    func onCellSelected(model: CellModel, closure: @escaping (TeamAddPlayerCell.AddPlayerStatus) -> ()) {
        if model is TeamAddPlayerModelItem {
            let teamModel = model as! TeamAddPlayerModelItem
            self.viewModel.teamPersonInvitesViewModel.requestInvite(personId: teamModel.personModelItem.person.id) { result in
                switch result {
                case .success(let personInvited):
                    Print.m(personInvited)
                    
                    var invitedPerson = personInvited
                    var teamInvites = self.viewModel.teamPersonInvitesViewModel.teamPersonInvites.value
                    
                    if let person = self.viewModel.findedTeamPersons.value?.filter({ model -> Bool in
                        return model.personModelItem.person.id == personInvited.person?.getId() ?? personInvited.person?.getValue()?.id
                    }).first?.personModelItem.person {
                        invitedPerson.person = IdRefObjectWrapper<Person>(person)
                    }
                    teamInvites.append(invitedPerson)
                    self.viewModel.teamPersonInvitesViewModel.teamPersonInvites.accept(teamInvites)
                    closure(.success)
                case .message(let message):
                    Print.m(message.message)
                    closure(.failure)
                case .failure(.error(let error)):
                    Print.m(error)
                    closure(.failure)
                case .failure(.notExpectedData):
                    Print.m("not expected data")
                    closure(.failure)
                }
            }
        }
    }
    
}

// MARK: Choose Region Protocol

extension TeamAddPlayersVC: ChooseRegionResult {
    
    func complete(region: RegionMy) {
        self.regionBtn.setTitle(region.name, for: .normal)
        self.viewModel.choosedRegion.accept(region)
        
        self.viewModel.fetch()
    }
    
}

// MARK: Search controller

extension TeamAddPlayersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            self.tableView.removeInfiniteScroll()
//            self.refreshControl = nil
            if searchController.searchBar.text?.count ?? 0 > 2 {
                filterContentForQuery(searchController.searchBar.text!)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForQuery(_ query: String, scope: String = "All") {
//        if (CACurrentMediaTime() - currentTimeOfSearch) > 5 {
//            if query.count > 1 {
//                Print.m("Query is \(query)")
//                presenter.findPersons(query: query)
//            }
//        updateUI()
//        self.tableView.reloadData()
//        }
    }
    
    func isFiltering() -> Bool {
        let isFilter = searchController.isActive && !searchBarIsEmpty()
        return isFilter
    }
}
