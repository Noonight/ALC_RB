//
//  PlayersTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayersTableViewController: UITableViewController {

    let presenter = PlayersPresenter()

    let disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var players = Players()
    
    var searchedPlayers = Players()
    
    let cellId = "cell_players"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPresenter()
        
        configureSearchController()
        
        tableView.tableFooterView = UIView()
    }

    func updateUI() {
        tableView.reloadData()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск игроков"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        configureSearchAction()
    }
    
    func configureSearchAction() {
//        searchController.rx.
//        let editText = UITextField(frame: CGRect(x: 0, y: 0, width: 150, height: view.frame.height))
//        view.addSubview(editText)
//
//        editText.rx.text.orEmpty
//            .debounce(1, scheduler: MainScheduler.instance)
//            .
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .subscribeOn(MainScheduler.instance)
        
    }
}

extension PlayersTableViewController: PlayersTableView {
    func initPresenter() {
        presenter.attachView(view: self)
        
        presenter.getPlayers()
    }
    
    func onGetPlayersSuccess(_ players: Players) {
        self.players = players
        updateUI()
    }
}

extension PlayersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(players.people.count)
        return players.people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlayerTableViewCell
        
        let player = players.people[indexPath.row]
        
        configureCell(cell, player)
        
//        cell.mName.text = players.people[indexPath.row].surname + " " + players.people[indexPath.row].name + " " + players.people[indexPath.row].lastname
//
//        if (player.birthdate != "" || player.birthdate != nil || player.birthdate != " ") {
//            cell.mBirthDate.text = players.people[indexPath.row].birthdate.UTCToLocal(from: .utc, to: .local)
//        }
//
//        if (player.photo != nil || player.photo != "" || player.photo != " ") {
//            presenter.getImage(imageName: players.people[indexPath.row].photo ?? "") { image in
//                cell.mImage.image = image.af_imageRoundedIntoCircle()
//            }
//        }
        
        //debugPrint("section: \(indexPath.section), row: \(indexPath.row)")
        
        return cell
    }
    
    func configureCell(_ cell: PlayerTableViewCell, _ player: Person) {
        let fullName = player.surname + " " + player.name
        
        if (fullName.count > 3) {
            cell.mName.text = fullName
        } else {
            cell.mName.text = "Не указано"
        }
        
        if (player.birthdate.count > 3) {
            cell.mBirthDate.text = player.birthdate.UTCToLocal(from: .utc, to: .local)
        } else {
            cell.mBirthDate.text = ""
        }
        
        if (player.photo?.count ?? "".count > 3) {
            presenter.getImage(imageName: player.photo ?? "") { image in
                cell.mImage.image = image.af_imageRoundedIntoCircle()
            }
        } else {
            cell.mImage.image = UIImage(named: "ic_logo")
        }
    }
}

extension PlayersTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row)")
    }
}

extension PlayersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension PlayersTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
