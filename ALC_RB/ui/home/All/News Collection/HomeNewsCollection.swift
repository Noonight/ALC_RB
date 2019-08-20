//
//  HomeNewsTable.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

extension NewsElement : CellModel {}

final class HomeNewsCollection: NSObject {
    
    let cellNib = UINib(nibName: "HomeNewsCollectionViewCell", bundle: Bundle.main)
    
    var cellActions: CellActions?
    var dataSource: [NewsElement] = []
    
    init(actions: CellActions) {
        self.cellActions = actions
    }
    
}

extension HomeNewsCollection: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.cellActions != nil
        {
            self.cellActions?.onCellSelected(model: dataSource[indexPath.row])
        }
    }
    
}

extension HomeNewsCollection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeNewsCollectionViewCell.ID , for: indexPath) as! HomeNewsCollectionViewCell
        
        cell.configure(self.dataSource[indexPath.row])
        
        return cell
    }
    
    
}
