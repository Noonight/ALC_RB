//
//  RefereeProtocolPlayerTeamTwoTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class RefereeProtocolPlayerTeamTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNumber_label: UILabel!
    @IBOutlet weak var playerName_label: UILabel!
    @IBOutlet weak var playerEvents_view: PlayerEventView!
    
    var cellModel: RefereeProtocolPlayerTeamCellModel?
    
    func configure(cellModel: RefereeProtocolPlayerTeamCellModel?) {
        reset()
        
        guard let model = cellModel else { return }
        
//        self.playerNumber_label.text = model.player?.number
        self.playerName_label.text = model.person?.getSurnameNP()
        self.playerEvents_view.viewModel = cellModel?.eventsModel
    }
    
    func reset() {
        self.playerName_label.text = ""
        self.playerNumber_label.text = "00"
        self.playerEvents_view.viewModel = RefereeProtocolPlayerEventsModel()
    }
}
