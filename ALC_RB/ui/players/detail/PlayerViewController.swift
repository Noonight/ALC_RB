//
//  PlayerViewController.swift
//  ALC_RB
//
//  Created by ayur on 24.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var mPhoto: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mBirthDate: UILabel!
    @IBOutlet weak var pastLeaguesTable: UITableView!
    
    struct PlayerDetailContent {
        var person: Person
        var photo: UIImage
        
        init(person: Person, photo: UIImage) {
            self.person = person
            self.photo = photo
        }
    }
    
    var content: PlayerDetailContent? {
        didSet {
            reloadUI()
        }
    }
    
    let cellId = "cell_player_past_league"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadUI() {
        pastLeaguesTable.reloadData()
        mPhoto.image = content?.photo
        mName.text = content?.person.name
        mBirthDate.text = content?.person.birthdate.UTCToLocal(from: .utc, to: .local)
    }
}

extension PlayerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (content!.person.pastLeagues.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlayerPastLeaguesTableViewCell
        
        configureCell(cell: cell, model: (content!.person.pastLeagues[indexPath.row]))
        
        return cell
    }
    
    func configureCell(cell: PlayerPastLeaguesTableViewCell, model: PastLeague) {
        cell.mLeague.text = model.name
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
