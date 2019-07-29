//
//  EventMaker.swift
//  ALC_RB
//
//  Created by ayur on 29.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class EventMaker: NSObject {
    static let SIZE = CGRect(x: 0, y: 0, width: 278, height: 70)
    static let BACKGROUND_COLOR = UIColor(white: 0, alpha: 0.1)
    
    let eventView = AddEventView(frame: SIZE)
    var onHideTriggered: ((LIEvent) -> ())
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = BACKGROUND_COLOR
        view.alpha = 0 // hidden
        
        return view
    }()
    var curMatchId: String!
    var curPlayerId: String!
    var curTime: String!
    
    init(callBack: @escaping (LIEvent) -> ()) {
        self.onHideTriggered = callBack
    }
    
    // MARK: WORK WORK VIEW CONTROLLER
    
    public func showWith(matchId: String, playerId: String, time: String) { // TODO modify time
        self.curMatchId = matchId
        self.curPlayerId = playerId
        self.curTime = time
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundView)
            window.addSubview(eventView)
            
            backgroundView.addGestureRecognizer(UIGestureRecognizer(
                target: self,
                action: #selector(hideBackgroundView))
            )
            
            eventView.setCenterFromParent()
            eventView.setCenterFromParentTrue()
            
            backgroundView.frame = window.frame
            backgroundView.alpha = 0
            
            eventView.alpha = 0
            eventView.isHidden = false
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                
                self.eventView.alpha = 1
            }, completion: nil)
        }
    }
    
    public func hide(eventType: LIEvent.EventType) -> LIEvent {
        return LIEvent().with(
            id: self.curMatchId,
            eventType: eventType.rawValue,
            player: self.curPlayerId,
            time: self.curTime
        )
    }
    
    // MARK: HELPERS
    
    @objc func hideBackgroundView() {
        UIView.animate(withDuration: 0.5)
        {

            self.backgroundView.alpha = 0
            self.eventView.alpha = 0
//            if let window = UIApplication.shared.keyWindow {
//                self.eventView.alpha = 0
//            }
        }
        self.eventView.isHidden = true
    }
    
}

extension EventMaker: EventCallBack {
    func onGoalPressed(playerId: String) {
        onHideTriggered(hide(eventType: .goal))
    }
    
    func onSuccessPenaltyPressed(playerId: String) {
        self.onHideTriggered(hide(eventType: .penalty))
    }
    
    func onFailurePenaltyPressed(playerId: String) {
        Print.m("No event for failure penalty") // NO EVENT FOR FAILURE PENALTY
    }
    
    func onYellowCardPressed(playerId: String) {
        self.onHideTriggered(hide(eventType: .yellowCard))
    }
    
    func onRedCardPressed(playerId: String) {
        self.onHideTriggered(hide(eventType: .redCard))
    }
    
    
}
