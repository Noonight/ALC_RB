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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.newsCollection?.dataSource = [
            NewsElement(id: "1", caption: "1", img: "1", content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ", createdAt: "01", updatedAt: "01"),
            NewsElement(id: "1", caption: "1", img: "1", content: "content 1", createdAt: "01", updatedAt: "01"),
            NewsElement(id: "1", caption: "1", img: "1", content: "content 1", createdAt: "01", updatedAt: "01"),
            NewsElement(id: "1", caption: "1", img: "1", content: "content 1", createdAt: "01", updatedAt: "01"),
            NewsElement(id: "1", caption: "1", img: "1", content: "content 1", createdAt: "01", updatedAt: "01"),
            NewsElement(id: "1", caption: "1", img: "1", content: "content 1", createdAt: "01", updatedAt: "01"),
        ]
        self.news_collection.reloadData()
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
        Print.m("here")
    }
    
    func setupNewsTableDataSource() {
        self.newsCollection!.dataSource = self.viewModel.prepareNewsDataSource()
        self.news_collection.reloadData()
    }
    
    func setupScheduleTable() {
        self.scheduleTable = HomeScheduleTable(actions: self)
        self.matches_table.delegate = self.scheduleTable
        self.matches_table.dataSource = self.scheduleTable
        Print.m("here")
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
