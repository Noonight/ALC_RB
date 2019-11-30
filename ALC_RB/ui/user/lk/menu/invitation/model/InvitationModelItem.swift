//
//  InvitationModelItem.swift
//  ALC_RB
//
//  Created by ayur on 30.11.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

final class InvitationModelItem {
    
    var inviteStatus: TeamPlayerInviteStatus
 
    init(inviteStatus: TeamPlayerInviteStatus) {
        self.inviteStatus = inviteStatus
    }
    
    var teamName: String? {
        return inviteStatus.team?.getValue()?.name
    }
    
    var trainerName: String? {
        return inviteStatus.team?.getValue()?.trainer?.getValue()?.name
    }
    
    var leagueBeginDate: String? {
        return inviteStatus.team?.getValue()?.league?.getValue()?.beginDate?.toFormat(.local)
    }
    
    var leagueEndDate: String? {
        return inviteStatus.team?.getValue()?.league?.getValue()?.endDate?.toFormat(.local)
    }
    
    var leagueDate: String? {
        return "\(leagueBeginDate ?? "") - \(leagueEndDate ?? "")"
    }
    
    var tourneyLeagueName: String? {
        if let tourneyName = self.tourneyName {
            return "\(tourneyName). \(leagueName ?? "")"
        }
        return leagueName
    }
    
    var tourneyName: String? {
        return inviteStatus.team?.getValue()?.league?.getValue()?.tourney?.getValue()?.name
    }
    
    var leagueName: String? {
        return inviteStatus.team?.getValue()?.league?.getValue()?.name
    }
    
}
