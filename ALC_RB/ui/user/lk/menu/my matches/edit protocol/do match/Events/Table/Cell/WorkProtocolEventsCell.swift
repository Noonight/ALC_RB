//
//  WorkProtocolEventsCell.swift
//  ALC_RB
//
//  Created by ayur on 19.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class WorkProtocolEventsCell: UITableViewCell {

    static let ID = "id_work_protocol_events"
    
    @IBOutlet weak var teamOneTitleLabel: UILabel!
    @IBOutlet weak var teamTwoTitleLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var eventModelItem: WorkProtocolEventModelItem! {
        didSet {
            switch eventModelItem.team {
            case .one:
                self.teamOneTitleLabel.text = eventModelItem.creatorName
                self.teamTwoTitleLabel.text = nil
            case .two:
                self.teamTwoTitleLabel.text = eventModelItem.creatorName
                self.teamOneTitleLabel.text = nil
            }
            eventImage.image = eventModelItem.typeImage
        }
    }
    
}
