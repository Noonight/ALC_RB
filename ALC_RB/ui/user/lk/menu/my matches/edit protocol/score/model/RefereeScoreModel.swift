//
//  File.swift
//  ALC_RB
//
//  Created by ayur on 29.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class RefereeScoreModel {
    struct TableDataSource
    {
        struct Event
        {
            var event: LIEvent
            var curScore: Int
        }
        var eventsTeamOne: [Event] = []
        var eventsTeamTwo: [Event] = []
    }
    
    var leagueDetailModel: LeagueDetailModel!
    var match: LIMatch!
    
    var teamOnePlayers: ProtocolPlayersController!
    var teamTwoPlayers: ProtocolPlayersController!
    var events: ProtocolEventsController!
    
    init(match: LIMatch, leagueDetailModel: LeagueDetailModel, teamOnePlayers: ProtocolPlayersController, teamTwoPlayers: ProtocolPlayersController, events: ProtocolEventsController) {
        self.match = match
        self.leagueDetailModel = leagueDetailModel
        self.teamOnePlayers = teamOnePlayers
        self.teamTwoPlayers = teamTwoPlayers
        self.events = events
    }
    
    // MARK: PREPARE FOR USING IN VIEW CONTROLLER
    
//    func prepareTableDataSource() -> TableDataSource
//    {
//        var dataSourec = TableDataSource
//
//    }
    
    func prepareTeamTitle(team: ClubTeamHelper.TeamEnum) -> String {
        return ClubTeamHelper.getTeamTitle(league: self.leagueDetailModel.leagueInfo.league, match: self.match, team: team)
    }
    
    func prepareResultScore() -> String {
        guard let curScore = self.match.score else { return "0 : 0" }
        return parseScoreString(score: curScore)
    }
    
    // MARK: HELPERS
    
//    private func getTeamEvents(team: ClubTeamHelper.TeamEnum) -> [LIEvent]
//    {
//        
//    }
    
    private func parseScoreString(score: String) -> String {
        if score.count != 0 {
            var scores = score.components(separatedBy: ":")
            return "\(scores[0]) : \(scores[1])"
        }
        return "0 : 0"
    }
}
