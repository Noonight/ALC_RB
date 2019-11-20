//
//  TourneyTable.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 20.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class TourneyTable: NSObject {
    
    let cellNib = UINib(nibName: "MyTourneyCell", bundle: Bundle.main)
    
    var dataSource: [TourneyModelItem] = []
    let cellActions: TableActions
    
    init(cellActions: TableActions) {
        self.cellActions = cellActions
    }
    
}

extension TourneyTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        cellActions.onCellSelected(model: dataSource[indexPath.section].leagues![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 32, y: 0, width: tableView.frame.size.width, height: MyTourneyHeaderView.height))
        let header =  MyTourneyHeaderView()
        sectionView.addSubview(header)
        sectionView.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        sectionView.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        sectionView.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        sectionView.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        header.backgroundColor = .white
        header.separatorColor = tableView.separatorColor
        header.tourneyModelItem = dataSource[section]
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MyTourneyHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyTourneyHeaderView.height
    }
}

extension TourneyTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].leagues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTourneyCell.ID, for: indexPath) as! MyTourneyCell
        
        cell.accessoryType = .disclosureIndicator
        cell.leagueModelItem = dataSource[indexPath.section].leagues?[indexPath.row]
        
        return cell
    }
    
}
