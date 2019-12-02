//
//  EditScheduleRefereesModel.swift
//  ALC_RB
//
//  Created by ayur on 02.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct EditScheduleRefereesModel {
    
    let firstReferee = BehaviorRelay<Person?>(value: nil)
    let secondReferee = BehaviorRelay<Person?>(value: nil)
    let thirdReferee = BehaviorRelay<Person?>(value: nil)
    let timekeeper = BehaviorRelay<Person?>(value: nil)
    
    init(first: Person?, second: Person?, third: Person?, time: Person?) {
        self.firstReferee.accept(first)
        self.secondReferee.accept(second)
        self.thirdReferee.accept(third)
        self.timekeeper.accept(time)
    }
    
    func setup(referees: [Referee]?) {
        guard let referees = referees else { return }
        for referee in referees {
            guard let type = referee.type else { return }
            switch type {
            case .firstReferee:
                self.firstReferee.accept(referee.person?.getValue())
            case .secondReferee:
                self.secondReferee.accept(referee.person?.getValue())
            case .thirdReferee:
                self.thirdReferee.accept(referee.person?.getValue())
            case .timekeeper:
                self.timekeeper.accept(referee.person?.getValue())
            }
        }
    }
    
    func getRefereesArray() -> EditMatchReferees.Referees {
        var resultArray: [EditMatchReferee] = []
        
        if let firstReferee = firstReferee.value {
            resultArray.append(EditMatchReferee(type: .firstReferee, person: firstReferee.id))
        }
        
        if let secondReferee = secondReferee.value {
            resultArray.append(EditMatchReferee(type: .secondReferee, person: secondReferee.id))
        }
        
        if let thirdReferee = thirdReferee.value {
            resultArray.append(EditMatchReferee(type: .thirdReferee, person: thirdReferee.id))
        }
        
        if let timekeeper = timekeeper.value {
            resultArray.append(EditMatchReferee(type: .timekeeper, person: timekeeper.id))
        }
        
        return EditMatchReferees.Referees(referees: resultArray)
    }
}
