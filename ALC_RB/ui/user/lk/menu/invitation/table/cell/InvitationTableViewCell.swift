//
//  InvitationTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 11.03.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class InvitationTableViewCell: UITableViewCell {

    static let ID = "invitation_cell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tournamentImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamTrainer: UILabel!

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var inviteModelItem: InvitationModelItem! {
        didSet {
            self.titleLabel.text = self.inviteModelItem.tourneyLeagueName
            self.dateLabel.text = self.inviteModelItem.leagueDate
            self.teamName.text = self.inviteModelItem.teamName
            self.teamTrainer.text = self.inviteModelItem.trainerName
        }
    }
    
    var okCallBack: ((InvitationModelItem) -> ())?
    var cancelCallBack: ((InvitationModelItem) -> ())?
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        cancelCallBack?(self.inviteModelItem)
    }
    
    @IBAction func okBtnPressed(_ sender: UIButton) {
        okCallBack?(self.inviteModelItem)
    }
    
}
