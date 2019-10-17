//
//  HomeNewsTable.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class HomeNewsCollection: NSObject {
    
    let cellNib = UINib(nibName: "HomeNewsCollectionViewCell", bundle: Bundle.main)
    
    var cellActions: TableActions?
    var dataSource: [NewsModelItem] = []
    
    init(actions: TableActions) {
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
        
        cell.newsModelItem = dataSource[indexPath.row]
        
        return cell
    }
    
}

extension HomeNewsCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        
        return CGSize(width: size, height: size)
    }
}
