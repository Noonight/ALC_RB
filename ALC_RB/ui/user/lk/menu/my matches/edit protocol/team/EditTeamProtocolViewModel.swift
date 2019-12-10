//
//  EditTeamProtocolViewModel.swift
//  ALC_RB
//
//  Created by ayur on 08.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class EditTeamProtocolViewModel {
    
    let loading = PublishSubject<Bool>()
    let error = PublishSubject<Error?>()
    let message = PublishSubject<SingleLineMessage>()
    let noTeamPlayers = PublishSubject<Bool>()
    
    var team = BehaviorRelay<Team?>(value: nil)
    var match = BehaviorRelay<Match?>(value: nil)
    
    var players = BehaviorRelay<[PlayerSwitchModelItem]>(value: [])
    
    let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func setupDataModel() {
        var resultArray = [PlayerSwitchModelItem]()
        guard let teamPlayers = team.value?.players else { assertionFailure(""); return }
        guard let matchPlayers = match.value?.playersList else { return }
        
        if teamPlayers.count == 0 {
            self.noTeamPlayers.onNext(true)
            return
        }
        
        for player in teamPlayers {
            Print.m()
            let playerSwitchInstance = PlayerSwitchModelItem(player: player)
            for person in matchPlayers {
                if player.id == person.getId() ?? person.getValue()?.id {
                    playerSwitchInstance.isRight = true
                } else {
                    playerSwitchInstance.isRight = false
                }
            }
            resultArray.append(playerSwitchInstance)
        }
        Print.m("PLAYERS OF TEAM: \(teamPlayers)")
        Print.m("PLAYERS OF MATCH: \(matchPlayers)")
        self.players.accept(resultArray)
    }
    
    func requestEditMatchPlayers() {
        self.loading.onNext(true)
        matchApi.post_changePlayers(match: prepareMatch()) { result in
            switch result {
            case .success(let changedMatch):
                self.loading.onNext(false)
                self.match.accept(changedMatch)
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
        }
    }
    
}

// MARK: - HELPER

extension EditTeamProtocolViewModel {
    
    private func prepareMatch() -> Match {
        var match: Match!
        if self.match.value != nil {
            match = self.match.value!
        } else {
            assertionFailure("Match cannot be empty")
        }
        
        match.setPlaingTeamPlayers(team: team.value!, newTeamPlayers: getPlaingTeamPlayers().map({ playerSwitch -> IdRefObjectWrapper<Person> in
            return IdRefObjectWrapper<Person>((playerSwitch.player.player.person?.getValue())!)
        }))
        
        return match
    }
    
    private func getPlaingTeamPlayers() -> [PlayerSwitchModelItem] {
        return self.players.value.filter({ playerSwitch -> Bool in
            return playerSwitch.isRight == true
        })
    }
}
