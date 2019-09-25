//
//  HomeAllVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 19/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class HomeAllVC: UIViewController {

    @IBOutlet weak var news_collection: UICollectionView!
    @IBOutlet weak var matches_table: IntrinsicTableView!
//    @IBOutlet weak var announces_table: IntrinsicTableView!
    
    var newsCollection: HomeNewsCollection?
    var scheduleTable: HomeScheduleTable?
    var announcesTable: HomeAnnouncesTable?
    
    var viewModel = HomeAllVM(networkRep: HomeAllNetworkRep(dataManager: ApiRequests()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNewsTable()
        self.setupScheduleTable()
//        self.setupAnnouncesTable()
        
        self.viewModel.updateAll {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
                self.setupAllDataSources()
//            })
        }
    }
}

// MARK: EXTENSIONS

// MARK: SETUP

extension HomeAllVC {
    
    func setupNewsTable() {
        self.newsCollection = HomeNewsCollection(actions: self)
        self.news_collection.delegate = self.newsCollection
        self.news_collection.dataSource = self.newsCollection
        self.news_collection.register(self.newsCollection?.cellNib, forCellWithReuseIdentifier: HomeNewsCollectionViewCell.ID)
    }
    
    func setupNewsTableDataSource() {
        self.newsCollection!.dataSource = self.viewModel.prepareNewsDataSource()
        self.news_collection.reloadData()
    }
    
    func setupScheduleTable() {
        self.scheduleTable = HomeScheduleTable(actions: self)
        self.matches_table.delegate = self.scheduleTable
        self.matches_table.dataSource = self.scheduleTable
    }
    
    func setupScheduleTableDataSource() {
        self.scheduleTable!.dataSource = self.viewModel.prepareScheduleDataSource()
        self.matches_table.reloadData()
    }
    
//    func setupAnnouncesTable() {
//        self.announcesTable = HomeAnnouncesTable(actions: self)
//        self.announces_table.delegate = self.announcesTable
//        self.announces_table.dataSource = self.announcesTable
//    }
//
//    func setupAnnouncesTableDataSource() {
//        self.announcesTable!.dataSource = self.viewModel.prepareAnnouncesDataSource()
//        self.announces_table.reloadData()
//    }
    
    func setupAllDataSources() {
        self.setupNewsTableDataSource()
        self.setupScheduleTableDataSource()
//        self.setupAnnouncesTableDataSource()
    }
}

// MARK: ACTIONS

extension HomeAllVC {
    
}

extension HomeAllVC: CellActions {
    func onCellSelected(model: CellModel) {
        switch model  {
        case is NewsElement:
            Print.m("news cell selected")
        case is MmMatch:
            Print.m("match cell selected")
        case is AnnounceElement:
            Print.m("announce cell selected")
        default:
            Print.m("default tap here")
        }
    }
}

// MARK: HELPERS

extension HomeAllVC {
    
}