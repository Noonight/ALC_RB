//
//  MatchProtocolPresenter.swift
//  ALC_RB
//
//  Created by mac on 08.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class EditMatchProtocolPresenter {
    
    let teamApi: TeamApi
    let personApi: PersonApi
    let matchApi: MatchApi
    
    var match: Match!
    
    init(teamApi: TeamApi, personApi: PersonApi, matchApi: MatchApi) {
        self.teamApi = teamApi
        self.personApi = personApi
        self.matchApi = matchApi
    }
    
    func fetchTeamPlayers(team: TeamEnum, resultMy: @escaping (ResultMy<Team, RequestError>) -> ()) {
        let params = ParamBuilder<Team.CodingKeys>()
            .select(StrBuilder().add([.players, .trainer]))
            .populate(StrBuilder().add([.players, .trainer]))
        
        switch team {
        case .one:
            guard let team = match.teamOne else { return }
            params.add(key: .id, value: team.getId() ?? team.getValue()?.id)
            guard let teamObj = team.getValue() else { assertionFailure("team is not object"); return }
            teamApi.get_teamPlayers(inTeam: teamObj, params: params.get(), resultMy: resultMy)
        case .two:
            guard let team = match.teamTwo else { return }
            params.add(key: .id, value: team.getId() ?? team.getValue()?.id)
            guard let teamObj = team.getValue() else { assertionFailure("team is not object"); return }
            teamApi.get_teamPlayers(inTeam: teamObj, params: params.get(), resultMy: resultMy)
        }
        
    }
    
    func fetchMatchPlayers() {
        matchApi.get_matchPlayers(inMatch: self.match) { result in
            switch result {
            case .success(let matchPlayers):
                
                self.match.playersList = matchPlayers.playersList
                
            case .message(let message):
                Print.m(message.message)
            case .failure(.error(let error)):
                Print.m(error)
            case .failure(.notExpectedData):
                Print.m("not expected data")
            }
        }
    }
    
    func fetchMatchReferees() {
        
        matchApi.get_matchReferees(inMatch: self.match) { result in
            switch result {
            case .success(let matchReferees):
                
                self.match.referees = matchReferees.referees
                
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
