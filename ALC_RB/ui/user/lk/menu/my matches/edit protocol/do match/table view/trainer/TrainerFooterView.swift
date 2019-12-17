//
//  TrainerFooterView.swift
//  ALC_RB
//
//  Created by ayur on 17.12.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TrainerFooterView: UIView {

    @IBOutlet var container_view: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yellowCardImage: UIImageView!
    @IBOutlet weak var redCardImage: UIImageView!
    @IBOutlet weak var yellowCardLabel: UILabel!
    @IBOutlet weak var redCardLabel: UILabel!
    
    var trainer: TrainerWorkProtocolModelItem! {
        didSet {
            nameLabel.text = trainer.name
            yellowCardImage.isHidden = trainer.isYellowCard ? true : false
            redCardImage.isHidden = trainer.isRedCard ? true : false
            if let yellowCards = trainer.yellowCards {
                yellowCardLabel.text = String(yellowCards)
            }
            if let redCards = trainer.redCards {
                redCardLabel.text = String(redCards)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("AutoGoalFooterView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
