//
//  TeamPlayers.swift
//  ALC_RB
//
//  Created by ayur on 25.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamPlayers: NSObject {
    
    var dataSource: [String] = []
    
}

extension TeamPlayers: UITableViewDelegate {
    
}

extension TeamPlayers: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
