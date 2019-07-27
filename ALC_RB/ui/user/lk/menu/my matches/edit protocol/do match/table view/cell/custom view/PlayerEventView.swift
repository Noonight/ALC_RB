//
//  PlayerEventView.swift
//  ALC_RB
//
//  Created by ayur on 27.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PlayerEventView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var goalsView: UIView!
    @IBOutlet weak var successfulPenaltyGoalsView: UIView!
    @IBOutlet weak var failurePenaltyGoalsView: UIView!
    @IBOutlet weak var redCardView: UIView!
    @IBOutlet weak var yellowCardView: UIView!
    
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var successfulPenaltyGoalsLabel: UILabel!
    @IBOutlet weak var failurePenaltyGoalsLabel: UILabel!
    @IBOutlet weak var yellowCardsLabel: UILabel!
 
    var viewModel: RefereeProtocolPlayerEventsModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        self.resetUI()
        
        if viewModel?.goals != 0 {
            self.goalsView.isHidden = false
            self.goalsLabel.text = String(viewModel!.goals)
        }
        if viewModel?.successfulPenaltyGoals != 0 {
            self.successfulPenaltyGoalsView.isHidden = false
            self.successfulPenaltyGoalsLabel.text = String(viewModel!.successfulPenaltyGoals)
        }
        if viewModel?.failurePenaltyGoals != 0 {
            self.failurePenaltyGoalsView.isHidden = false
            self.failurePenaltyGoalsLabel.text = String(viewModel!.failurePenaltyGoals)
        }
        if viewModel?.yellowCards != 0 {
            self.yellowCardView.isHidden = false
            self.yellowCardsLabel.text = String(viewModel!.yellowCards)
        }
        if viewModel?.redCard == true {
            self.redCardView.isHidden = false
        }
    }
    
    func resetUI() {
        self.goalsView.isHidden = true
        self.successfulPenaltyGoalsView.isHidden = true
        self.failurePenaltyGoalsView.isHidden = true
        self.yellowCardView.isHidden = true
        self.redCardView.isHidden = true
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
        Bundle.main.loadNibNamed("PlayerEventView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
