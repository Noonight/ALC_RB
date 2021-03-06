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
        var table: [[Event]] = []
        
        var teamOneFouls: [Event] = []
        var teamTwoFouls: [Event] = []
        
        var teamOneAutoGoals: [Event] = []
        var teamTwoAutoGoals: [Event] = []
        mutating func reset() {
            table = []
        }
    }
    
    @IBOutlet weak var addEventBarBtn: UIBarButtonItem!
    @IBOutlet weak var helpQBarBtn: UIBarButtonItem!
    
    // MARK: - Variables
    
    let cellId = "event_protocol_cell"
    
    var tableModel = TableStruct()
//    var destinationModel = [Event]()
    var fetchedPersons: [Person] = []
    
//    var model: MyMatchesRefTableViewCell.CellModel!
    
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
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItems = nil
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
    
    func findUniqueTime(events: [Event]) -> [Event.Time] {
        var allEventTimes: [Event.Time] = []
        for event in events {
//            if !allEventTimes.contains(event.time!) {
                allEventTimes.append(event.time!)
//            }
        }
        return allEventTimes
    }
    
    func findUniqueEvent(destination: [Event]) -> [Event.eType] {
        var allEventTypes: [Event.eType] = []
        for event in destination {
//            if !allEventTypes.contains(event.type!) {
                allEventTypes.append(event.type!)
//            }
        }
        return allEventTypes
    }
    
    func findTimeEvents(at time: Event.Time) -> [Event] {
        var timeEvents: [Event] = []
        for event in eventsController.events {
            if event.time == time {
                timeEvents.append(event)
            }
        }
        return timeEvents
    }
    
    func prepareTableModel(destination: [Event]) {
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
            return tableModel.table[section][0].time.map { $0.rawValue }
        } else {
            return "***"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditEventsProtocolTableViewCell

        configureCell(cell: cell, model: tableModel.table[indexPath.section][indexPath.row])

        return cell
    }
    
    func configureCell(cell: EditEventsProtocolTableViewCell, model: Event) {
        
        func setupCell(person: Person) {
            cell.name_label.text = person.getSurnameNP()
            // DEPRECATED: person does not contain system event image
//            cell.event_type_image.image = model.getSystemEventImage()
            
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
            return person.id == model.player?.getId() ?? model.player?.getValue()?.id ?? ""
        }).first {
            setupCell(person: person)
        } else {
            let hud = cell.showLoadingViewHUD()
            presenter.getPlayer(player: model.player?.getId() ?? model.player?.getValue()?.id ?? "", get_player:
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
//            destination.model = self.model
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
