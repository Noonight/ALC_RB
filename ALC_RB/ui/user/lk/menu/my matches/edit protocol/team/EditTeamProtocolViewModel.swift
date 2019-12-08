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
    
    var team = BehaviorRelay<Team?>(value: nil)
    var match = BehaviorRelay<Match?>(value: nil)
    
    var players = BehaviorRelay<[PlayerSwitchModelItem]>(value: [])
    
    let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func setupDataModel() {
        var resultArray = [PlayerSwitchModelItem]()
        guard let teamPlayers = team.value?.players else { return }
        guard let matchPlayers = match.value?.playersList else { return }
        for player in teamPlayers {
            for person in matchPlayers {
                if player.id == person.getId() ?? person.getValue()?.id {
                    resultArray.append(PlayerSwitchModelItem(player: player, isRight: true))
                }
            }
        }
        self.players.accept(resultArray)
    }
    
    func requestEditMatchPlayers() {
        matchApi.post_changePlayers(match: <#T##Match#>, resultMy: <#T##(ResultMy<Match, RequestError>) -> ()#>)
    }
    
}

// MARK: - HELPER

extension EditTeamProtocolViewModel {
    
    private func prepareMatch() -> Match {
        var match: Match!
        if self.match.value != nil {
            match = self.match.value!
            
        }
        return match
    }
    
    private func prepareMatchPlayersList(matchPlayers: [String]) -> [String] {
        var personIds = [String]()
        
        
        
        return personIds
    }
    
}
