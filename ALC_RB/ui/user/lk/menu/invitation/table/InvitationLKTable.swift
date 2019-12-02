//
//  InvitationLKTable.swift
//  ALC_RB
//
//  Created by ayur on 01.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class InvitationLKTable: NSObject {
    
    var dataSource = [InvitationModelItem]()
    
    let tableActions: InvitationTableActions
    
    init(tableActions: InvitationTableActions) {
        self.tableActions = tableActions
    }
    
}

extension InvitationLKTable: UITableViewDelegate {
    
}

extension InvitationLKTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvitationTableViewCell.ID, for: indexPath) as! InvitationTableViewCell
        
        cell.inviteModelItem = dataSource[indexPath.row]
        
        cell.okCallBack = { model in
            cell.showAccessoryLoading()
            self.tableActions.onOkPressed(model: model, closure: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    cell.hideAccessoryLoading()
                })
            })
        }
        cell.cancelCallBack = { model in
            cell.showAccessoryLoading()
            self.tableActions.onCancelPressed(model: model, closure: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    cell.hideAccessoryLoading()
                })
            })
        }
        
        return cell
    }
    
}
