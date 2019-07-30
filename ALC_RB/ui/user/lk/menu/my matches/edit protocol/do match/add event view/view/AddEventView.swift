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
    
    @IBOutlet weak var success_penalty_label: UILabel!
    @IBOutlet weak var failure_penalty_label: UILabel!
    
    @IBOutlet var goal_tap: UITapGestureRecognizer!
    @IBOutlet var success_penalty_tap: UITapGestureRecognizer!
    @IBOutlet var failure_penalty_tap: UITapGestureRecognizer!
    @IBOutlet var yellow_card_tap: UITapGestureRecognizer!
    @IBOutlet var red_card_tap: UITapGestureRecognizer!
    
    @IBOutlet weak var minus_state_image: UIImageView!
    @IBOutlet weak var active_minus_state_image: UIImageView!
    @IBOutlet weak var rotate_view_image: UIImageView!
    
    var callBacks: EventCallBack? {
        didSet {
            setupCallBacks()
        }
    }
    
    var playerId: String!
    var rotated = false {
        didSet {
            updateRotatedView()
        }
    }
    var stateMinusActive = false {
        didSet {
            updateMinusState()
        }
    }
    
    func setupCallBacks() {
        if self.callBacks != nil {
            success_penalty_tap.addTarget(self, action: #selector(onSuccessPenalty))
            failure_penalty_tap.addTarget(self, action: #selector(onFailurePenalty))
            yellow_card_tap.addTarget(self, action: #selector(onYellowCard))
            red_card_tap.addTarget(self, action: #selector(onRedCard))
            
            minus_state_image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMinusState)))
            rotate_view_image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRotateView)))
        }
    }
    
    // MARK: ACTIONS
    
    @objc func onMinusState() {
        self.stateMinusActive = !self.stateMinusActive
    }
    
    @objc func onRotateView() {
        self.rotated = !self.rotated
    }
    
    @IBAction func onGoalPressed(_ sender: UITapGestureRecognizer) {
        goal_image.animateTap()
        callBacks?.onGoalPressed(playerId: self.playerId)
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
    
    // MARK: HELPER
    
    func updateMinusState() {
        if self.stateMinusActive == true
        {
            self.active_minus_state_image.isHidden = false
        } else {
            self.active_minus_state_image.isHidden = true
        }
    }
    
    func updateRotatedView() {
        UIView.animate(withDuration: 0.2) {
            if self.rotated == true
            {
                self.container_view.transform = CGAffineTransform(scaleX: 1, y: 1);
                self.success_penalty_image.transform = CGAffineTransform(scaleX: 1, y: 1);
                self.failure_penalty_image.transform = CGAffineTransform(scaleX: 1, y: 1);
            } else {
                self.container_view.transform = CGAffineTransform(scaleX: -1, y: 1);
                self.success_penalty_image.transform = CGAffineTransform(scaleX: -1, y: 1);
                self.failure_penalty_image.transform = CGAffineTransform(scaleX: -1, y: 1);
            }
        }
    }
    
    // MARK: INIT
    
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
