//
//  PlayerViewController.swift
//  ALC_RB
//
//  Created by ayur on 24.12.2018.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Lightbox

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
        
        init(person: Person, photo: UIImage?) {
            self.person = person
            if let image = photo {
                self.photo = image
            } else {
                self.photo = #imageLiteral(resourceName: "ic_logo")
            }
        }
        
        init() {
            self.person = Person()
            self.photo = #imageLiteral(resourceName: "ic_logo")
        }
    }
    
    var content = PlayerDetailContent() {
        didSet {
//            reloadUI()
//            self.mPhoto.image = self.content.photo.af_imageRoundedIntoCircle()
        }
    }
    
    let cellId = "cell_player_past_league"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        reloadUI()
        pastLeaguesTable.tableFooterView = UIView()
        
        initLightBox()
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
        
        // DEPRECATED: person does not have past leagues
        
//        if content.person.pastLeagues.count == 0 {
//            showEmptyView()
//        } else {
//            hideEmptyView()
//        }
        
        pastLeaguesTable.reloadData()
        mPhoto.image = content.photo.af_imageRoundedIntoCircle()
//        mName.text = content?.person.name
        mName.text = content.person.getFullName()
//        Print.d(message: "\(content?.person.birthdate)")
        mBirthDate.text = content.person.birthdate!.toFormat(DateFormats.local.rawValue)
    }
    
    func prepareTableView() {
        pastLeaguesTable.dataSource = self
        pastLeaguesTable.delegate = self
    }
    
    var backgroundView: UIView = UIView()
}
// MARK: LightBox
extension PlayerViewController {
    func initLightBox() {
        self.mPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
        self.mPhoto.isUserInteractionEnabled = true
    }
    
    @objc func imageTap() {
        let images = [LightboxImage(image: self.content.photo)]
        let controller = LightboxController(images: images)
        controller.dynamicBackground = false
        
        present(controller, animated: true, completion: nil)
    }
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
//        return self.content.person.pastLeagues.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlayerPastLeaguesTableViewCell
        
//        configureCell(cell: cell, model: (content.person.pastLeagues[indexPath.row]))
        
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
