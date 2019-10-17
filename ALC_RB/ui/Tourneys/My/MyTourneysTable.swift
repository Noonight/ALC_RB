//
//  MyTourneysTable.swift
//  ALC_RB
//
//  Created by ayur on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class MyTourneysTable: NSObject {
    
    let cellNib = UINib(nibName: "MyTourneyCell", bundle: Bundle.main)
    let noCellNib = UINib(nibName: "NoLeaguesCell", bundle: Bundle.main)
    
    var dataSource: [TourneyModelItem] = []
    let cellActions: TableActions
    
    init(cellActions: TableActions) {
        self.cellActions = cellActions
    }
    
}

extension MyTourneysTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if dataSource[indexPath.section].leagues?.count != 0 {
            cellActions.onCellSelected(model: dataSource[indexPath.section].leagues![indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 32, y: 0, width: tableView.frame.size.width, height: 80))
        let header =  MyTourneyHeaderView()
        sectionView.addSubview(header)
        sectionView.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        sectionView.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        sectionView.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        sectionView.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        header.backgroundColor = .white
        header.separatorColor = tableView.separatorColor
        header.tourneyModelItem = dataSource[section]
        
        if dataSource[section].leagues?.count == 1 {
            header.isDisclosure = true
            header.action = { tourneyModelItem in
                self.cellActions.onHeaderPressed(model: tourneyModelItem.leagues!.first!)
            }
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension MyTourneysTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let leagues = dataSource[section].leagues else { return dataSource[section].leagues?.count ?? 0 }
        if leagues.count == 1 {
            return 0
        }
//        if leagues.count == 0 {
//            return 1
//        }
        return dataSource[section].leagues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTourneyCell.ID, for: indexPath) as! MyTourneyCell
        
        cell.accessoryType = .disclosureIndicator
        cell.leagueModelItem = dataSource[indexPath.section].leagues?[indexPath.row]
        
        return cell
    }
    
}
