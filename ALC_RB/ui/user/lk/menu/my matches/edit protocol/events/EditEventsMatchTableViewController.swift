//
//  EventsMatchTableViewController.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
import Kingfisher

class EditEventsMatchTableViewController: UITableViewController {
    enum SegueIdentifiers {
        static let add = "segue_add_event"
    }
    
    // MARK: - TableStruct
    
    struct TableStruct {
        var table: [[LIEvent]] = []
        mutating func reset() {
            table = []
        }
    }
    
    // MARK: - IB
    
    @IBOutlet weak var addEventBarBtn: UIBarButtonItem!
    @IBOutlet weak var helpQBarBtn: UIBarButtonItem!
    
    // MARK: - Variables
    
    let cellId = "event_protocol_cell"
    
    var tableModel = TableStruct()
//    var destinationModel = [LIEvent]()
    var fetchedPersons: [Person] = []
    
    var model: MyMatchesRefTableViewCell.CellModel!
    
    let presenter = EditEventsMatchPresenter()
    let menuLauncher = MenuLauncher()
    
    var eventsController: ProtocolEventsController!
    var teamOneController: ProtocolPlayersController!
    var teamTwoController: ProtocolPlayersController!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.tableFooterView = UIView()
        
        prepareTableModel(destination: eventsController.events)

        setupNavBtn()
    }
    
    // MARK: - Setup nav button
    
    func setupNavBtn() {
        helpQBarBtn.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .normal)
        helpQBarBtn.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)], for: .selected)
    }
    
    // MARK: - Action btn
    
    @IBAction func onHelpBarBtnPressed(_ sender: UIBarButtonItem) {
        showMenu()
    }

    // MARK: - Setup menu
    
    func showMenu() {
        menuLauncher.showMenu()
    }
    
    // MARK: - Prepare tableModel
    
    func findUniqueTime(events: [LIEvent]) -> [String] {
        var allEventTimes: [String] = []
        for event in events {
            if !allEventTimes.contains(event.time) {
                allEventTimes.append(event.time)
            }
        }
        return allEventTimes
    }
    
    func findUniqueEvent(destination: [LIEvent]) -> [String] {
        var allEventTypes: [String] = []
        for event in destination {
            if !allEventTypes.contains(event.eventType) {
                allEventTypes.append(event.eventType)
            }
        }
        return allEventTypes
    }
    
    func findTimeEvents(at time: String) -> [LIEvent] {
        var timeEvents: [LIEvent] = []
        for event in eventsController.events {
            if event.time == time {
                timeEvents.append(event)
            }
        }
        return timeEvents
    }
    
    func prepareTableModel(destination: [LIEvent]) {
        tableModel.reset()
        defer {
            tableView.reloadData()
        }
        let events = destination
        let uniqueTime = findUniqueTime(events: events)
        for time in uniqueTime {
            tableModel.table.append(findTimeEvents(at: time))
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.table.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.table[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableModel.table[section].count > 0 {
            return tableModel.table[section][0].time
        } else {
            return "***"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditEventsProtocolTableViewCell

        configureCell(cell: cell, model: tableModel.table[indexPath.section][indexPath.row])

        return cell
    }
    
    func configureCell(cell: EditEventsProtocolTableViewCell, model: LIEvent) {
        
        func setupCell(person: Person) {
            cell.name_label.text = person.getSurnameNP()
            cell.event_type_image.image = model.getSystemEventImage()
            
            if let url = person.photo {
                let url = ApiRoute.getImageURL(image: url)
                let processor = DownsamplingImageProcessor(size: cell.photo_image.frame.size)
                    .append(another: CroppingImageProcessorCustom(size: cell.photo_image.frame.size))
                    .append(another: RoundCornerImageProcessor(cornerRadius: cell.photo_image.getHalfWidthHeight()))
                
                cell.photo_image.kf.indicatorType = .activity
                cell.photo_image.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "ic_logo"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            } else {
                cell.photo_image.image = #imageLiteral(resourceName: "ic_logo")
            }
        }
        
        if let person = fetchedPersons.filter({ person -> Bool in
            return person.id == model.player
        }).first {
            setupCell(person: person)
        } else {
            let hud = cell.showLoadingViewHUD()
            presenter.getPlayer(player: model.player, get_player:
            { (person) in
                self.fetchedPersons.append(person.person)
                setupCell(person: person.person)
                hud.hide(animated: true)
            }) { (error) in
                hud.setToFailureWith(detailMessage: error.localizedDescription)
            }
        }
        
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eventsController.removeFirst(tableModel.table[indexPath.section][indexPath.row])
            tableModel.table[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.add,
            let destination = segue.destination as? AddEventsProtocolViewController
        {
            destination.eventsController = self.eventsController
            destination.model = self.model
            destination.teamOneController = self.teamOneController
            destination.teamTwoController = self.teamTwoController
        }
    }
}

extension EditEventsMatchTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
