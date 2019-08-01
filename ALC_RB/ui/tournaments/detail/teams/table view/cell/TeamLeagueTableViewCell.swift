//
//  TeamLeagueTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

enum TeamPlaceInLeague {
    case firstThree
    case secondThree
    case any
}

class TeamLeagueTableViewCell: UITableViewCell {
    static let FIRST_THREE_COLOR = UIColor(red: 211, green: 0, blue: 0)
    static let SECOND_THREE_COLOR = UIColor(red: 0, green: 97, blue: 225)
    
    @IBOutlet weak var position_label: UILabel!
    @IBOutlet weak var team_btn: UIButton!
    @IBOutlet weak var games_label: UILabel!
    @IBOutlet weak var rm_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    @IBOutlet weak var wins_label: UILabel!
    
    func configure(team: LITeam?) {
        if let curTeam = team {
            team_btn.setTitle(curTeam.name, for: .normal)
            games_label.text = String(curTeam.wins! + curTeam.losses!)
            rm_label.text = String(curTeam.goals! - curTeam.goalsReceived!)
            score_label.text = String(curTeam.groupScore!)
            wins_label.text = String(curTeam.wins!)
            
            guard let curPlace = curTeam.place else { return }
            preparePosition(place: curPlace)
            
            return
        }
        team_btn.setTitle("Команды нет", for: .normal)
        games_label.text = ""
        rm_label.text = ""
        score_label.text = ""
        wins_label.text = ""
    }
    
    func preparePosition(place: Int) {
        self.position_label.text = String(place)
        if 1 ... 3 ~= place
        {
//            Print.m(place)
            setPosition(position: .firstThree)
            return
        }
        if 4 ... 6 ~= place
        {
//            Print.m(place)
            setPosition(position: .secondThree)
            return
        }
        setPosition(position: .any)
    }
    
    func setPosition(position: TeamPlaceInLeague) {
        switch position {
        case .firstThree:
            self.setupColor(color: TeamLeagueTableViewCell.FIRST_THREE_COLOR)
        case .secondThree:
            self.setupColor(color: TeamLeagueTableViewCell.SECOND_THREE_COLOR)
        case .any:
            self.setupColor(color: .black)
        }
    }
    
    func setupColor(color: UIColor) {
        self.position_label.textColor = color
        self.team_btn.setTitleColor(color, for: .normal)
        self.games_label.textColor = color
        self.rm_label.textColor = color
        self.score_label.textColor = color
        self.wins_label.textColor = color
    }
    
    
}
