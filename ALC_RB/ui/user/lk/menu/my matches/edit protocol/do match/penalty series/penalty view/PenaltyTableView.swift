//
//  PenaltyTableView.swift
//  ALC_RB
//
//  Created by ayur on 13.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PenaltyTableView: NSObject {
    enum Texts {
        static let series = "серия"
    }
    enum CellIdentifiers {
        static let CELL = "cell_id_for_instance_penalty_state"
    }
    
    let cellNib = UINib(nibName: "PenaltySeriesTableViewCell", bundle: Bundle.main)
    var dataSource: [GroupPenaltyState] = []
    
    init(dataSource: [GroupPenaltyState]) {
        self.dataSource = dataSource
    }
    
    override init() { }
}

// MARK: EXTENSIONS

// MARK: DELEGATE

extension PenaltyTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: DATA SOURCE

extension PenaltyTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section + 1) \(Texts.series)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CELL, for: indexPath) as! PenaltySeriesTableViewCell
        
        cell.initView(group: dataSource[indexPath.section])
        
        return cell
    }
    
    
}
