//
//  TeamAddPlayersTable.swift
//  ALC_RB
//
//  Created by ayur on 28.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class TeamAddPlayersTable: NSObject {
    
    var dataSource: [TeamAddPlayerModelItem] = []
    
    var tableActions: TeamAddTableActions?
    
    init(tableActions: TeamAddTableActions) {
        self.tableActions = tableActions
    }
    
}

extension TeamAddPlayersTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var cell: TeamAddPlayerCell?
        
        if dataSource[indexPath.row].status == nil {
            cell = tableView.cellForRow(at: indexPath) as? TeamAddPlayerCell
            
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.startAnimating()
            cell?.accessoryType = .none
            cell?.accessoryView = activityIndicator
        }
        
        tableActions?.onCellSelected(model: dataSource[indexPath.row], closure: { status in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                switch status {
                case .success:
                    
                    cell?.accessoryType = .checkmark
                    cell?.accessoryView = nil
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        cell?.accessoryType = .none
                        cell?.accessoryView = nil
                        
                        var tmp = cell?.teamAddPlayer
                        tmp?.status = .pending
                        cell?.teamAddPlayer = tmp
                        
                        for i in 0..<self.dataSource.count {
                            if tmp?.personModelItem.person.id == self.dataSource[i].personModelItem.person.id {
                                self.dataSource[i] = tmp!
                            }
                        }
//                        cell?.setNeedsDisplay()
                    })
                    
                case .failure:
                    
                    let warningImg = UIImageView(image: UIImage(named: "ic_warning"))
                    warningImg.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    
                    cell?.accessoryType = .none
                    cell?.accessoryView = warningImg
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        let addImg = UIImageView(image: UIImage(named: "ic_blue_plus"))
                        addImg.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                        cell?.accessoryType = .none
                        cell?.accessoryView = addImg
                    })
                    
                case .none:
                    
                    cell?.accessoryType = .none
                    cell?.accessoryView = nil
                    
                }
            })
        })
    }
}

extension TeamAddPlayersTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamAddPlayerCell.ID, for: indexPath) as! TeamAddPlayerCell
        
        cell.teamAddPlayer = dataSource[indexPath.row]
        
        if cell.teamAddPlayer.status == nil {
            let addImg = UIImageView(image: UIImage(named: "ic_blue_plus"))
            addImg.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            cell.accessoryType = .none
            cell.accessoryView = addImg
        }
        
        return cell
    }
    
    
}
