//
//  MyMatchesTable.swift
//  ALC_RB
//
//  Created by ayur on 03.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class MyMatchesTable: NSObject {
    
    var dataSource = [MyMatchModelItem]()
    
}

extension MyMatchesTable: UITableViewDelegate {
    
}

extension MyMatchesTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyMatchesRefTableViewCell.ID, for: indexPath) as! MyMatchesRefTableViewCell
        
        return cell
    }
    
    
}
