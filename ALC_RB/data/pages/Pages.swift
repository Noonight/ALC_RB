//
//  Pages.swift
//  ALC_RB
//
//  Created by ayur on 16.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

// for pagination if server request do not use pages pattern
struct Pages {
    private var itemCounts = 0
    private var pageCounts = 0
    private var itemPerPage = 20
    private var currentPage = 1
    
    init(countOfItems: Int, itemPerPage: Int = 20) {
        self.itemPerPage = itemPerPage
        self.itemCounts = countOfItems
        self.currentPage = 0
        self.pageCounts = self.itemCounts / self.itemPerPage
        let dot = self.itemCounts % self.itemPerPage
        if dot != 0 {
            self.pageCounts = self.pageCounts + 1
        }
    }
    
    // available pages from 1 to pages count
    mutating func setCurrentPage(_ page: Int) -> Bool {
        for i in 1...pageCounts {
            if page == i {
                self.currentPage = page
                return true
            }
        }
        return false
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    func getPageCounts() -> Int {
        return self.pageCounts
    }
    
    // page from 1 to count pages
    func getItemsAtPage(_ page: Int) -> [Int: Int]? {
        for i in 1...pageCounts {
            if page == i && page == 1 { // first page
                return [0 : itemPerPage]
            }
            if page == i && page == pageCounts { // last page
                return [(page - 1) * itemPerPage : itemCounts]
            }
            let itemRight = page * itemPerPage
            return [itemRight - itemPerPage : itemRight]
        }
        return nil
    }
}
