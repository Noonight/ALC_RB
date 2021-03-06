//
//  MenuOption.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

enum UserMenuOption: Int, CustomStringConvertible {
    
    // -- Player
    case invites
    case tourneys
    // TODO: case clubs
    case teams
    // -- Referee
    case schedule
    case myMatches
    
    case signOut
    
    var description: String {
        switch self {
        case .invites: return "Приглашения"
        case .tourneys: return "Мой турнир"
        // TODO: case .Clubs: return "Клубы"
        case .teams: return "Команды"
        // -- Referee
        case .schedule: return "Расписание"
        case .myMatches: return "Мои матчи"
            
        case .signOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .invites: return UIImage(named: "ic_inv") ?? UIImage()
        case .tourneys: return UIImage(named: "ic_trophy") ?? UIImage()
        // TODO: case .Clubs: return UIImage(named: "ic_cl") ?? UIImage()
        case .teams: return UIImage(named: "ic_commands") ?? UIImage()
        // -- Referee
        case .schedule: return UIImage(named: "ic_timetable") ?? UIImage()
        case .myMatches: return UIImage(named: "ic_whistle") ?? UIImage()
        
        case .signOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
    
}

enum PlayerMenuOption: Int, CustomStringConvertible {
    
    case Invites
    case Tourneys
    case Clubs
    case Teams
    //    case Referees
    case SignOut
    
    var description: String {
        switch self {
        case .Invites: return "Приглашения"
        case .Tourneys: return "Мой турнир"
        case .Clubs: return "Клубы"
        case .Teams: return "Команды"
        //        case .Referees: return "Судьи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Invites: return UIImage(named: "ic_inv") ?? UIImage()
        case .Tourneys: return UIImage(named: "ic_trophy") ?? UIImage()
        case .Clubs: return UIImage(named: "ic_cl") ?? UIImage()
        case .Teams: return UIImage(named: "ic_commands") ?? UIImage()
        //        case .Referees: return #imageLiteral(resourceName: "ic_referee")
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}

enum RefereeMenuOption: Int, CustomStringConvertible {
    
    case MyMatches
    case SignOut
    
    var description: String {
        switch self {
        case .MyMatches: return "Мои матчи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .MyMatches: return #imageLiteral(resourceName: "ic_whistle") // tmp solve
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}

enum MainRefereeMenuOption: Int, CustomStringConvertible {
    
    case Schedule
    case MyMatches
    case Referees
    case SignOut
    
    var description: String {
        switch self {
        case .Schedule: return "Распиание"
        case .MyMatches: return "Мои матчи"
        case .Referees: return "Судьи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Schedule: return #imageLiteral(resourceName: "ic_timetable") // tmp solve
        case .MyMatches: return #imageLiteral(resourceName: "ic_whistle")
        case .Referees: return #imageLiteral(resourceName: "ic_referee") // tmp solve
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}


