//
//  EventsMatchTableViewController.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EventsMatchTableViewController: BaseStateTableViewController {

    // MARK: - TableStruct
    
    struct TableStruct {
        var table: [[LIEvent]] = []
    }
    
    // MARK: - Variables
    
    let cellId = "event_protocol_cell"
    
    var tableModel = TableStruct()
    var destinationModel = [LIEvent]()
    
    let presenter = EventsMatchPresenter()
    let menuLauncher = MenuLauncher()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPresenter()
        setEmptyMessage(message: "Здесь будут отображаться события матча")
        prepareTableModel(destination: destinationModel)
        self.refreshControl = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.tableFooterView = UIView()
        
        setupNavBtn()
    }
    
    // MARK: - Setup nav button
    
    func setupNavBtn() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: " ? ", style: .plain, target: self, action: #selector(handleNavBtn))
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 26)], for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Helvetica-Bold", size: 20)], for: UIControl.State.selected)
    }
    
    // MARK: - Action btn
    
    @objc func handleNavBtn() {
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
        if destination.count > 0 {
            setState(state: .normal)
            let events = destination
            let uniqueEventTypes = findUniqueHeader(destination: events)
            for uniqEvent in uniqueEventTypes {
                var arrEvents: [LIEvent] = events.filter { (event) -> Bool in
                    return event.eventType == uniqEvent
                }
                tableModel.table.append(arrEvents)
            }
        } else {
            setState(state: .empty)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventsProtocolTableViewCell

        configureCell(cell: cell, model: tableModel.table[indexPath.section][indexPath.row])

        return cell
    }
    
    func configureCell(cell: EventsProtocolTableViewCell, model: LIEvent) {
        presenter.getPlayer(player: model.player, get_player: { (person) in
//            cell.name_label.text = person.person.getFullName()
            cell.name_label.text = person.person.getSurnameNP()
            cell.type_label.text = model.getEventType().getAbbreviation()
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
}

extension EventsMatchTableViewController: MvpView {
    func initPresenter() {
        presenter.attachView(view: self)
    }
}
