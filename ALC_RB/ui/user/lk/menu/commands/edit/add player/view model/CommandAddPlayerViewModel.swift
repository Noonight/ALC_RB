//
//  CommandAddPlayerViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 03/05/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol CommandAddPlayerViewModelDelegate: class {
    func onFetchPersonsCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchPersonsFailed(with error: Error)
}

final class CommandAddPlayerViewModel {
    private weak var delegate: CommandAddPlayerViewModelDelegate?
    
    private var persons: [Person] = []
    private var total = 0
    private var isFetchInProgress = false
    
    private var limit = 20
    
    var offset = 0
    
    let apiClient = ApiRequests()
    let personApi = PersonApi()
    
    init(delegate: CommandAddPlayerViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return persons.count
    }
    
    func person(at index: Int) -> Person {
        return persons[index]
    }
    
    func fetchPersons(offset: Int) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        personApi.get_person() { result in
            switch result {
            case .success(let persons):
                self.isFetchInProgress = false
                
                self.total = persons.count
                
                self.persons.append(contentsOf: persons)
                
                let indexPathsToReload = self.calculateIndexPathToReload(from: persons)
                
                self.delegate?.onFetchPersonsCompleted(with: indexPathsToReload)
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
                self.isFetchInProgress = false
                self.delegate?.onFetchPersonsFailed(with: error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
        
//        apiClient.get_players(limit: limit, offset: offset, get_success: { (players) in
////            DispatchQueue.main.async {
//                self.isFetchInProgress = false
//
//
//                self.total = players.count
//
////                if players.people.first?.id != self.persons.last?.id {
////                    self.persons.append(contentsOf: players.people)
////
////                    let indexPathsToReload = self.calculateIndexPathToReload(from: players.people)
////                    self.delegate?.onFetchPersonsCompleted(with: indexPathsToReload)
////                } else {
////                    self.delegate?.onFetchPersonsCompleted(with: .none)
////                }
//
//            self.persons.append(contentsOf: players.people)
//
//            let indexPathsToReload = self.calculateIndexPathToReload(from: players.people)
//
//            self.delegate?.onFetchPersonsCompleted(with: indexPathsToReload)
//
////                if players
////            }
//        }) { (error) in
////            DispatchQueue.main.async {
//                self.isFetchInProgress = false
//                self.delegate?.onFetchPersonsFailed(with: error)
////            }
//        }
    }
    
    func calculateIndexPathToReload(from newPersons: [Person]) -> [IndexPath] {
        let startIndex = persons.count - newPersons.count
        let endIndex = startIndex + newPersons.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
