//
//  AddEventView.swift
//  ALC_RB
//
//  Created by ayur on 29.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol EventCallBack {
    func onGoalPressed(playerId: String)
    func onSuccessPenaltyPressed(playerId: String)
    func onFailurePenaltyPressed(playerId: String)
    func onYellowCardPressed(playerId: String)
    func onRedCardPressed(playerId: String)
}

class AddEventView: UIView {

    @IBOutlet var container_view: UIView!
    
    @IBOutlet weak var goal_image: UIImageView!
    @IBOutlet weak var success_penalty_image: UIImageView!
    @IBOutlet weak var failure_penalty_image: UIImageView!
    @IBOutlet weak var yellow_card_image: UIImageView!
    @IBOutlet weak var red_card_image: UIImageView!
    
    @IBOutlet var goal_tap: UITapGestureRecognizer!
    @IBOutlet var success_penalty_tap: UITapGestureRecognizer!
    @IBOutlet var failure_penalty_tap: UITapGestureRecognizer!
    @IBOutlet var yellow_card_tap: UITapGestureRecognizer!
    @IBOutlet var red_card_tap: UITapGestureRecognizer!
    
    var callBacks: EventCallBack? {
        didSet {
            setupCallBacks()
        }
    }
    
    var playerId: String!
    
    func setupCallBacks() {
        if self.callBacks != nil {
            goal_tap.addTarget(self, action: #selector(onGoal))
            success_penalty_tap.addTarget(self, action: #selector(onSuccessPenalty))
            failure_penalty_tap.addTarget(self, action: #selector(onFailurePenalty))
            yellow_card_tap.addTarget(self, action: #selector(onYellowCard))
            red_card_tap.addTarget(self, action: #selector(onRedCard))
        }
    }
    
    @objc func onGoal() {
        goal_image.animateTap()
        callBacks?.onGoalPressed(playerId: self.playerId)
    }
    
    @objc func onSuccessPenalty() {
        success_penalty_image.animateTap()
        callBacks?.onSuccessPenaltyPressed(playerId: self.playerId)
    }
    
    @objc func onFailurePenalty() {
        failure_penalty_image.animateTap()
        callBacks?.onFailurePenaltyPressed(playerId: self.playerId)
    }
    
    @objc func onYellowCard() {
        yellow_card_image.animateTap()
        callBacks?.onYellowCardPressed(playerId: self.playerId)
    }
    
    @objc func onRedCard() {
        red_card_image.animateTap()
        callBacks?.onRedCardPressed(playerId: self.playerId)
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
        Bundle.main.loadNibNamed("AddEventView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
