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

class EditScheduleViewModel {
    
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<Error?> = PublishSubject()
    var message = PublishSubject<SingleLineMessage?>()
    
    var matchScheduleModel = BehaviorRelay<MatchScheduleModelItem?>(value: nil)
    
    var editedMatch = PublishSubject<Match>()
    
    let refereesModel: EditScheduleRefereesModel
    
    private let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
        self.refereesModel = EditScheduleRefereesModel(first: nil, second: nil, third: nil, time: nil)
    }
    
    func editMatchReferees() {
        self.loading.onNext(true)
        let patchMatch = Match(id: (self.matchScheduleModel.value?.match.id)!, referees: self.refereesModel.getReferees())
        matchApi.patch_matchReferees(match: patchMatch) { result in
            switch result {
            case .success(let editedMatch):
                self.editedMatch.onNext(editedMatch)
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
    
}
