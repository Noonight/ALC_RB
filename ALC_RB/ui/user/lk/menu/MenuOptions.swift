//
//  MenuOption.swift
//  ALC_RB
//
//  Created by ayur on 21.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

enum PlayerMenuOption: Int, CustomStringConvertible {
    
    case Invites
    case Tournaments
    case Clubs
    case Teams
    //    case Referees
    case SignOut
    
    var description: String {
        switch self {
        case .Invites: return "Приглашения"
        case .Tournaments: return "Турниры"
        case .Clubs: return "Клубы"
        case .Teams: return "Команды"
        //        case .Referees: return "Судьи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Invites: return UIImage(named: "ic_inv") ?? UIImage()
        case .Tournaments: return UIImage(named: "ic_trophy") ?? UIImage()
        case .Clubs: return UIImage(named: "ic_cl") ?? UIImage()
        case .Teams: return UIImage(named: "ic_commands") ?? UIImage()
        //        case .Referees: return #imageLiteral(resourceName: "ic_referee")
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}

enum RefereeMenuOption: Int, CustomStringConvertible {
    
    case DesignatedMatches
    case SignOut
    
    var description: String {
        switch self {
        case .DesignatedMatches: return "Мои матчи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .DesignatedMatches: return #imageLiteral(resourceName: "ic_whistle") // tmp solve
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}

enum MainRefereeMenuOption: Int, CustomStringConvertible {
    
    case Schedule
    case Referees
    case SignOut
    
    var description: String {
        switch self {
        case .Schedule: return "Распиание"
        case .Referees: return "Судьи"
        case .SignOut: return "Выйти"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Schedule: return #imageLiteral(resourceName: "ic_timetable") // tmp solve
        case .Referees: return #imageLiteral(resourceName: "ic_referee") // tmp solve
        case .SignOut: return UIImage(named: "ic_sign_out2") ?? UIImage()
        }
    }
}

