//
//  PaginationHelper.swift
//  ALC_RB
//
//  Created by ayur on 17.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct PaginationHelper {
    private var currentCount = 0
    private var totalCount = 0
    
    init(totalCount: Int, currentCount: Int) {
        self.totalCount = totalCount
        self.currentCount = currentCount
    }
    
    func getTotalCount() -> Int {
        return totalCount
    }
    
    mutating func setTotalCount(newCount: Int) {
        self.totalCount = newCount
    }
    
    func getCurrentCount() -> Int {
        return currentCount
    }
    
    mutating func setCurrentCount(newCount: Int) {
        self.currentCount = newCount
    }
}
