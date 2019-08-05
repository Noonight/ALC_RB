//
//  ProtocolTableEvents.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class ProtocolTableEvents: NSObject {
    enum Header {
        static let HEIGHT = 2
    }
    
    let headerView = UIView()
    
    var dataSource: [LIEvent] = []
    
}

extension ProtocolTableEvents: UITableViewDelegate {
    
}

extension ProtocolTableEvents: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.frame = CGRect(x: 0, y: 0, width: Int(tableView.frame.width), height: Header.HEIGHT)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
