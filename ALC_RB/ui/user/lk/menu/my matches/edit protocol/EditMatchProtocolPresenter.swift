//
//  MatchProtocolPresenter.swift
//  ALC_RB
//
//  Created by mac on 08.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol EditMatchProtocolView : MvpView {
    func requestEditProtocolSuccess(match: Match)
    func requestEditProtocolMessage(message: SingleLineMessage)
    func requestEditProtocolFailure(error: Error)
    
    func requestAcceptProtocolSuccess(message: SingleLineMessage)
    func requestAcceptProtocolFailure(error: Error)
}

class EditMatchProtocolPresenter: MvpPresenter<EditMatchProtocolViewController> {
    
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
            .select(StrBuilder().add([.trainer, .players]))
            .populate(StrBuilder().add([.trainer, .players]))
        
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
    
    func fetchMatchPlayers(resultMy: @escaping (ResultMy<Match, RequestError>) -> ()) {
        matchApi.get_matchPlayers(inMatch: self.match, resultMy: resultMy)
    }
    
    
}
