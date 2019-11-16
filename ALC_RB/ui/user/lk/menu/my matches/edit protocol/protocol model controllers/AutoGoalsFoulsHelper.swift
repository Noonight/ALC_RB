//
//  AutoGoalsFoulsHelper.swift
//  ALC_RB
//
//  Created by ayur on 31.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

// there is helper for counting auto goals and fouls for current team
class AutoGoalsFoulsHelper {
    static func autoGoals(for team: TeamEnum, playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> Int
    {
        return self.getPlayersAutoGoalEvents(playersController: playersController, eventsController: eventsController).count
    }
    
    static func autoGoals(for team: TeamEnum, playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> [Event]
    {
        return self.getPlayersAutoGoalEvents(playersController: playersController, eventsController: eventsController)
    }
    
    static func fouls(for team: TeamEnum, playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> Int
    {
        return self.getPlayersFoulsEvents(playersController: playersController, eventsController: eventsController).count
    }
    
    static func fouls(for team: TeamEnum, playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> [Event]
    {
        return self.getPlayersFoulsEvents(playersController: playersController, eventsController: eventsController)
    }
    
    // MARK: HELPERS
    
    static func getPlayersEvents(playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> [Event]
    {
        var events: [Event] = []
        
        for event in eventsController.events
        {
            if playersController.getPlayerByIdOfPlayingPlayers(event.player) != nil
            {
                events.append(event)
            }
        }
        
        return events
    }
    
    static func getPlayersAutoGoalEvents(playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> [Event]
    {
        var events: [Event] = []
        
        for event in eventsController.prepareAutoGoalEvents()
        {
            if playersController.getPlayerByIdOfPlayingPlayers(event.player) != nil
            {
                events.append(event)
            }
        }
        
        return events
    }
    
    static func getPlayersFoulsEvents(playersController: ProtocolPlayersController, eventsController: ProtocolEventsController) -> [Event]
    {
        var events: [Event] = []
        
        for event in eventsController.prepareFoulEvents()
        {
            if playersController.getPlayerByIdOfPlayingPlayers(event.player) != nil
            {
                events.append(event)
            }
        }
        
        return events
    }
}
