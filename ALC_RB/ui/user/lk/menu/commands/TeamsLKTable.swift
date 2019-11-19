//
//  TeamsLKTable.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamsLKTable: NSObject {
    
    var dataSource = [TeamGropModelItem]()
    
    init(dataSource: [TeamGropModelItem]) {
        self.dataSource = dataSource
    }
    
}

extension TeamsLKTable: UITableViewDelegate {
 
    
    
}

extension TeamsLKTable: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
    }
    
    
    
    
}
