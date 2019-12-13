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
    
    var changedMatch = PublishSubject<Match>()
    
    var playersChanged = PublishSubject<Void>()
    var players = BehaviorRelay<[PlayerSwitchModelItem]>(value: [])
    
    let matchApi: MatchApi
    
    init(matchApi: MatchApi) {
        self.matchApi = matchApi
    }
    
    func setupDataModel() {
        var resultArray = [PlayerSwitchModelItem]()
        guard let teamPlayers = team.value?.players else { assertionFailure(""); return }
        guard let matchPlayers = match.value?.playersList else { return }
        
        let tplayers = teamPlayers.map { player -> String in
            return player.person?.getId() ?? (player.person?.getValue()?.id)!
        }
        Print.m("teamPlayers: \(tplayers)")

        let pplayers = matchPlayers.map { person -> String in
            return person.getId() ?? (person.getValue()?.id)!
        }
        Print.m("matchPlayers: \(pplayers)")
        
        if teamPlayers.count == 0 {
            self.noTeamPlayers.onNext(true)
            return
        }
        
        for player in teamPlayers {
            
            var playerSwitchInstance = PlayerSwitchModelItem(player: player)
            
            if matchPlayers.contains(where: { person -> Bool in
                return person.getId() ?? (person.getValue()?.id)! == player.person?.getId() ?? (player.person?.getValue()?.id)!
            }) {
                playerSwitchInstance.isRight = true
            }
            
            resultArray.append(playerSwitchInstance)
        }
        self.players.accept(resultArray)
        self.playersChanged.onNext(())
    }
    
    func requestEditMatchPlayers() {
        self.loading.onNext(true)
//        prepareMatch()
        matchApi.post_changePlayers(match: prepareMatch()) { result in
            switch result {
            case .success(let changedMatch):
                self.loading.onNext(false)
                self.changedMatch.onNext(changedMatch)
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
        
        self.removeTeamPlayersFromMatch()
        
        var match: Match!
        if self.match.value != nil {
            match = self.match.value!
        } else {
            assertionFailure("Match cannot be empty")
        }
        Print.m("PLAING PLAYERS:")
        Print.m(getPlaingTeamPlayers().map({ playerSwitch -> String in
            return playerSwitch.player.player.person?.getId() ?? (playerSwitch.player.player.person?.getValue()?.id)!
        }))
        
        var plaingPlayers = getPlaingTeamPlayers().map { playerSwitch -> IdRefObjectWrapper<Person> in
            return playerSwitch.player.player.person!
        }
    
        match.playersList?.append(contentsOf: plaingPlayers)
        
        let players = match.playersList?.map({ person -> String in
            return person.getId() ?? (person.getValue()?.id)!
        })
        Print.m("match.playersList: \(players)")
        
        return match
    }
    
    
    
    private func removeTeamPlayersFromMatch() {
        guard var team = self.team.value else { return }
        guard var match = self.match.value else { return }
        
        guard var playersList = match.playersList else { return }
        guard var teamPlayers = team.players else { return }
        
        playersList.removeAll { person -> Bool in
            return teamPlayers.contains(where: { player -> Bool in
                return player.person?.getId() ?? player.person?.getValue()?.id == person.getId() ?? person.getValue()?.id
            })
        }
        
        match.playersList = playersList
        self.match.accept(match)
        
    }
    
    private func getPlaingTeamPlayers() -> [PlayerSwitchModelItem] {
        return self.players.value.filter({ playerSwitch -> Bool in
            return playerSwitch.isRight == true
        })
    }
}
