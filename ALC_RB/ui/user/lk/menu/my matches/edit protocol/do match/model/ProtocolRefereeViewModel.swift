//
//  ProtocolRefereeModel.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ProtocolRefereeViewModel {
    
    enum CurrentTime: String {
        case firstTime  = "1 тайм"
        case secondTime = "2 тайм"
        case moreTime   = "Дополнительное время"
        case penalty    = "Пенальти"
    }
    
    // current time uses for make event
    var currentTime: CurrentTime = .firstTime
    
    var match: LIMatch!
    
    var teamOnePlayersController: ProtocolPlayersController!
    var teamTwoPlayersController: ProtocolPlayersController!
    var refereesController: ProtocolRefereesController!
    var eventsController: ProtocolEventsController!
    
    init(match: LIMatch, teamOneModel: ProtocolPlayersController, teamTwoModle: ProtocolPlayersController,
         refereesModel: ProtocolRefereesController, eventsModel: ProtocolEventsController) {
        self.match = match
        self.teamOnePlayersController = teamOneModel
        self.teamTwoPlayersController = teamTwoModle
        self.refereesController = refereesModel
        self.eventsController = eventsModel
    }
    
    func prepareMatchId() -> String {
        return self.match.id
    }
    
    func prepareEditProtocol() -> EditProtocol {
        return EditProtocol(
            id: self.match.id,
            events: EditProtocol.Events(events: eventsController.events),
            playersList: self.getPlayersId()
        )
    }
    
    // MARK: Helpers
    
    fileprivate func getPlayersId() -> [String] {
        return connectPlayersOfTeamOneAndTwo().map({ liPlayer -> String in
            return liPlayer.playerId
        })
    }
    
    fileprivate func connectPlayersOfTeamOneAndTwo() -> [LIPlayer] {
        return [teamOnePlayersController.getPlayingPlayers(), teamTwoPlayersController.getPlayingPlayers()].flatMap({ liPlayer -> [LIPlayer] in
            return liPlayer
        })
    }
    
}
