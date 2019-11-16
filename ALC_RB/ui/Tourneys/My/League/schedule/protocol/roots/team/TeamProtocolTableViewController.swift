//
//  TeamProtocolTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamProtocolTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    let cellId = "team_protocol_cell"
    
    let presenter = TeamProtocolPresenter(dataManager: PersonApi())
    
    var players = [Person]()
    var fetchedPersons: [Person] = []
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //debugPrint(players)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamProtocolTableViewCell
        
        configureCell(cell: cell, model: players[indexPath.row])

        return cell
    }
    
    // MARK: - Configure cell
    
    func configureCell(cell: TeamProtocolTableViewCell, model: Person) {
        func setupCell(person: Person) {
            cell.name_label.text = person.getSurnameNP()
            if person.photo != nil {
                cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: person.photo!))
                //cell.photo_image.image?.af_imageRoundedIntoCircle()
            } else {
                cell.photo_image.image = UIImage(named: "ic_logo")
            }
        }
        
        if let curPerson = fetchedPersons.filter({ person -> Bool in
            return person.id == model.id
        }).first {
            setupCell(person: curPerson)
        }
        else
        {
//            presenter.getPlayer(player: model.playerId, get_player: { (player) in
//                //            cell.name_label.text = player.person.getFullName()
//                self.fetchedPersons.append(player.person)
//                setupCell(person: player.person)
//
//            }) { (error) in
//                debugPrint("get person info error")
//            }
            presenter.getPlayer(player: model.id) { result in
                switch result {
                case .success(let player):
                    self.fetchedPersons.append(player.first!)
                    setupCell(person: player.first!)
                case .message(let message):
                    self.showAlert(message: message.message)
                case .failure(.error(let error)):
                    Print.m(error)
                case .failure(RequestError.notExpectedData):
                    Print.m("See decoder")
                }
            }
        }
        
        cell.position_label.text = "DEPRECATED"
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension TeamProtocolTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
