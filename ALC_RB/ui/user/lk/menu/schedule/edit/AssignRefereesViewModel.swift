//
//  EditScheduleViewModel.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 13/06/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AssignRefereesViewModel {
    
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var message = PublishSubject<SingleLineMessage?>()
    
    var matchIsFetched = PublishSubject<Void>()
    var match = BehaviorRelay<Match?>(value: nil)
    
    var editedMatch = PublishSubject<Match>()
    
    var refereesModel: EditScheduleRefereesModel!
    
    private let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
        initReferees()
    }
    
    func initReferees() {
        self.refereesModel = EditScheduleRefereesModel(first: nil, second: nil, third: nil, time: nil)
    }
    
    func editMatchReferees() {
        self.loading.onNext(true)
        let patchMatch = Match(id: (self.match.value?.id)!, referees: self.refereesModel.getReferees())
        matchApi.patch_matchReferees(match: patchMatch) { result in
            switch result {
            case .success(let editedMatch):
                self.editedMatch.onNext(editedMatch)
                
                guard var match = self.match.value else { return }
                match.referees = editedMatch.referees
                self.match.accept(match)
            case .message(let message):
                Print.m(message.message)
                self.message.onNext(message)
            case .failure(.error(let error)):
                Print.m(error)
                self.error.onNext(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
                self.message.onNext(SingleLineMessage(Constants.Texts.NOT_VALID_DATA))
            }
            self.loading.onNext(false)
        }
    }
    
    func fetchMatchReferees() {
        
        matchApi.get_matchReferees(inMatch: self.match.value!) { result in
            switch result {
            case .success(let matchReferees):
                
                guard var match = self.match.value else { return }
                match.referees = matchReferees.referees
                self.match.accept(match)
                
                self.matchIsFetched.onNext(())
                
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
}
