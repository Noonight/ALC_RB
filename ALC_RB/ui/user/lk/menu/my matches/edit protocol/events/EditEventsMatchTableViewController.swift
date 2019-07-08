//
//  EventsMatchTableViewController.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EditEventsMatchTableViewController: UITableViewController {
    enum SegueIdentifiers {
        static let add = "segue_add_event"
    }
    
    // MARK: - TableStruct
    
    struct TableStruct {
        var table: [[LIEvent]] = []
    }
    
    // MARK: - IB
    
    @IBOutlet weak var addEventBarBtn: UIBarButtonItem!
    @IBOutlet weak var helpQBarBtn: UIBarButtonItem!
    
    // MARK: - Variables
    
    let cellId = "event_protocol_cell"
    
    var tableModel = TableStruct()
//    var destinationModel = [LIEvent]()
    
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
//        prepareTableModel(destination: destinationModel)
        prepareTableModel(destination: eventsController.events)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.tableFooterView = UIView()
        
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
    
    func findUniqueHeader(destination: [LIEvent]) -> [String] {
        var allEventTypes: [String] = []
        for event in destination {
            if !allEventTypes.contains(event.eventType) {
                allEventTypes.append(event.eventType)
            }
        }
        return allEventTypes
    }
    
    func prepareTableModel(destination: [LIEvent]) {
        let events = destination
        let uniqueEventTypes = findUniqueHeader(destination: events)
        for uniqEvent in uniqueEventTypes {
            var arrEvents: [LIEvent] = events.filter { (event) -> Bool in
                return event.eventType == uniqEvent
            }
            tableModel.table.append(arrEvents)
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
        return tableModel.table[section][0].time
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EditEventsProtocolTableViewCell

        configureCell(cell: cell, model: tableModel.table[indexPath.section][indexPath.row])

        return cell
    }
    
    func configureCell(cell: EditEventsProtocolTableViewCell, model: LIEvent) {
        presenter.getPlayer(player: model.player, get_player: { (person) in
            cell.name_label.text = person.person.getFullName()
            cell.type_label.text = model.getEventType().rawValue
            if person.person.photo != nil {
                self.presenter.getPlayerImage(player_photo: person.person.photo ?? " ", get_image: { (image) in
                    cell.photo_image.image = image
                })
            } else {
                cell.photo_image.image = UIImage(named: "ic_logo")
            }
        }) { (error) in
            
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
