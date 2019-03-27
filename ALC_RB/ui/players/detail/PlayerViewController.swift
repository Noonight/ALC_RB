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
    
    @IBOutlet var empty_view: UIView!
    @IBOutlet var tournament_label: UILabel!
    
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
            //reloadUI()
        }
    }
    
    let cellId = "cell_player_past_league"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        reloadUI()
        pastLeaguesTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        content?.person.pastLeagues = [
//            PastLeague(name: "Кубок города", tourney: "t", teamName: "Валенки123", place: "У-У"),
//            PastLeague(name: "Кубок поселка", tourney: "t", teamName: "Валенки123321", place: "У-У"),
//            PastLeague(name: "Кубок республики", tourney: "t", teamName: "Валенки123231", place: "У-У")
//        ]
        reloadUI()
    }
    func reloadUI() {
        
        if content?.person.pastLeagues.count == 0 {
            showEmptyView()
        } else {
            hideEmptyView()
        }
        
        pastLeaguesTable.reloadData()
        mPhoto.image = content?.photo
        mName.text = content?.person.name
        Print.d(message: "\(content?.person.birthdate)")
        if content?.person.birthdate.count ?? 0 > 3 {
            mBirthDate.text = content?.person.birthdate.UTCToLocal(from: .utc, to: .local)
        } else {
            mBirthDate.text = ""
        }
    }
    
    func prepareTableView() {
        pastLeaguesTable.dataSource = self
        pastLeaguesTable.delegate = self
    }
    
    var backgroundView: UIView = UIView()
}

extension PlayerViewController: EmptyProtocol {
    func showEmptyView() {
        let newEmptyView = EmptyViewNew()
        
//        backgroundView = UIView()
        backgroundView.frame = pastLeaguesTable.frame
        
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(newEmptyView)
        
        pastLeaguesTable.addSubview(backgroundView)
        
        newEmptyView.setText(text: "Здесь будут отображаться турниры игрока")
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = true
        
        newEmptyView.setCenterFromParent()
        newEmptyView.containerView.setCenterFromParent()
        
        backgroundView.setCenterFromParent()
        
        pastLeaguesTable.bringSubviewToFront(backgroundView)
        
//        pastLeaguesTable.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: pastLeaguesTable.frame.width, height: pastLeaguesTable.frame.height))
//        pastLeaguesTable.backgroundView?.addSubview(empty_view)
        pastLeaguesTable.separatorStyle = .none
//        empty_view.setCenterFromParent()
        tournament_label.text = ""
    }
    
    func hideEmptyView() {
        backgroundView.removeFromSuperview()
//        pastLeaguesTable.backgroundView = nil
        pastLeaguesTable.separatorStyle = .singleLine
        tournament_label.text = "Турниры"
    }
}

extension PlayerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //debugPrint(content?.person.pastLeagues)
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
