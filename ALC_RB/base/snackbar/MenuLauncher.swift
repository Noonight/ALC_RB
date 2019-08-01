//
//  MenuLauncher.swift
//  ALC_RB
//
//  Created by mac on 13.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class Menu: NSObject {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class MenuLauncher: NSObject {
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    let cellId = "menu_cell_id"
    
    //let cellId = "cellId"
    var menuSettings: [Menu] = {
        return [
            Menu(name: "Г - гол"),
            Menu(name: "А - автогол"),
            Menu(name: "Ф - фол"),
            Menu(name: "КК - красная карточка"),
            Menu(name: "ЖК - желтая карточка"),
            Menu(name: "Д - дисквалификация")
        ]
    }()
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideMenu)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 220
            
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            Print.m(self.collectionView.contentSize)
        }
    }
    
    @objc func hideMenu() {
        Print.m("hide view")
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MenuLauncherCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension MenuLauncher: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuSettings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuLauncherCell
        
        let menuGola = menuSettings[indexPath.item]
        cell.setting = menuGola
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension MenuLauncher: UICollectionViewDelegate {
    
}

extension MenuLauncher: UICollectionViewDelegateFlowLayout {
    
}
