//
//  TeamProtocolTableViewController.swift
//  ALC_RB
//
//  Created by ayur on 11.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditTeamProtocolTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    let cellId = "team_protocol_cell"
    
    let presenter = EditTeamProtocolPresenter()
    
//    var players = [LIPlayer]()
    
    var playersController: ProtocolPlayersController!
    
    // player id or _id
    var removedPlayers: [String] = []
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        initPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes =
                [
                    NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)
            ]
            if self.navigationController?.navigationBar.prefersLargeTitles != true {
                self.navigationController?.navigationBar.prefersLargeTitles = true
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onSaveBtnPressed(_ sender: UIBarButtonItem) {
        
        for i in 0..<self.playersController.players.count
        {
            self.playersController.setPlayerValue(playerId: self.playersController.players[i].playerId, value: true)
            for j in 0..<removedPlayers.count
            {
                if self.playersController.players[i].playerId == removedPlayers[j]
                {
                    self.playersController.setPlayerValue(playerId: playersController.players[i].playerId, value: false)
                }
            }
        }
        
        showAlert(title: "", message: "Для изменения команды нужно сохранить протокол") {
            self.navigationController?.popViewController(animated: true)
        }
//        navigationController?.popViewController(animated: true)
    }
    
    @objc func onSwitchChange(_ sender: UISwitch) {
        // if id of player is in removedPlayers array then delete from array
        // remove if found
        if sender.isOn
        {
            if removedPlayers.contains(playersController.players[sender.tag].playerId)
            {
                removedPlayers.removeAll { str -> Bool in
                    return str == playersController.players[sender.tag].playerId
                }
            }
        }
        // if id of player is not in removedPlayers array then append to array
        // append if not found
        if !sender.isOn
        {
            if !removedPlayers.contains(playersController.players[sender.tag].playerId)
            {
                removedPlayers.append(playersController.players[sender.tag].playerId)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersController.players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditTeamProtocolTableViewCell
        
        cell.switcher.tag = indexPath.row
        
        configureCell(cell: cell, model: playersController.players[indexPath.row])

        return cell
    }
    
    // MARK: - Configure cell
    
    func configureCell(cell: EditTeamProtocolTableViewCell, model: LIPlayer) {
        
        cell.switcher.addTarget(self, action: #selector(onSwitchChange(_:)), for: UIControl.Event.valueChanged)
        
        cell.switcher.isOn = playersController.getValueByKey(playerId: model.playerId) ?? true
        
        presenter.getPlayer(player: model.playerId, get_player: { (player) in
            cell.name_label.text = player.person.getFullName()
            if player.person.photo != nil {
                cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: player.person.photo!))
                //cell.photo_image.image?.af_imageRoundedIntoCircle()
            } else {
                cell.photo_image.image = UIImage(named: "ic_logo")
            }
        }) { (error) in
            debugPrint("get person info error")
        }
        cell.position_label.text = model.number
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditTeamProtocolTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
