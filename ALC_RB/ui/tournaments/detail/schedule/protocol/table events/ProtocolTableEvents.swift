//
//  ProtocolTableEvents.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

struct ProtocolAllEventsCellModel {
    var left_name: String
    var right_name: String
    var left_event: LIEvent.SystemEventType
    var right_event: LIEvent.SystemEventType
    
    init(left_name: String, right_name: String, left_event: LIEvent.SystemEventType, right_event: LIEvent.SystemEventType) {
        self.left_name = left_name
        self.right_name = right_name
        self.left_event = left_event
        self.right_event = right_event
    }
    
    init() {
        self.left_name = ""
        self.right_name = ""
        self.left_event = .non
        self.right_event = .non
    }
    // one of side can be empty
}

struct ProtocolAllEventsSectionTable {
    var eventsCellModel: [ProtocolAllEventsCellModel]
    var leftFooterFouls = 0 // for showing or not fouls
    var rightFooterFouls = 0 // also
    
    init(eventsCellModel: [ProtocolAllEventsCellModel], leftFooterFouls: Int, rightFooterFouls: Int) {
        self.eventsCellModel = eventsCellModel
        self.leftFooterFouls = leftFooterFouls
        self.rightFooterFouls = rightFooterFouls
    }
    
    init() {
        self.eventsCellModel = []
        self.leftFooterFouls = 0
        self.rightFooterFouls = 0
    }
}

class ProtocolTableEvents: NSObject {
    enum Header {
        static let HEIGHT = 2
    }
    enum CellIdentifiers {
        static let CELL = "protocol_table_all_cell"
    }
    
    let headerView = UIView()
    
    var dataSource: [ProtocolAllEventsSectionTable] = []
    
    init(dataSource: [ProtocolAllEventsSectionTable]) {
        self.dataSource = dataSource
    }
    
    override init() { }
}

extension ProtocolTableEvents: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProtocolTableEvents: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.frame = CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: Header.HEIGHT)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return ProtocolAllFooterView(frame: CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: ProtocolAllFooterView.HEIGHT))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].eventsCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CELL, for: indexPath) as! ProtocolAllTableEventsCell
        let model = dataSource[indexPath.section].eventsCellModel[indexPath.row]
        
        cell.cellModel = model
        
        return cell
    }
    
    
}
