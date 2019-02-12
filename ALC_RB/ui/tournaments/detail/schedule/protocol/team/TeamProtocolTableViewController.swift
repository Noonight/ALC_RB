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
    
    let presenter = TeamProtocolPresenter()
    
    var players = [LIPlayer]()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func configureCell(cell: TeamProtocolTableViewCell, model: LIPlayer) {
        presenter.getPlayer(player: model.playerId, get_player: { (player) in
            cell.name_label.text = player.person.getFullName()
            if player.person.photo != nil {
                cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: player.person.photo!))
                //cell.photo_image.image?.af_imageRoundedIntoCircle()
            } else {
                cell.photo_image.image = UIImage(named: "ic_logo")
            }
            //cell.photo_image.af_setImage(withURL: ApiRoute.getImageURL(image: player.person.photo ?? " "))
//            if !(player.person.photo != nil) {
//                self.presenter.getPlayerImage(photo: player.person.photo!, get_image: { (image) in
//                    cell.photo_image.image = image.af_imageRoundedIntoCircle()
//                })
//            } else {
//                cell.photo_image.image = UIImage(named: "ic_logo")
//            }
        }) { (error) in
            debugPrint("get person info error")
        }
        cell.position_label.text = model.number
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
