//
//  AutoGoalsMaker.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 12/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class AutoGoalsMaker: NSObject {
    static let SIZE = CGRect(x: 0, y: 0, width: 278, height: 153)
    static let BACKGROUND_COLOR = UIColor(white: 0, alpha: 0.1)
    
    let autoGoalsView = EditAutoGoalsView(frame: SIZE)
    var onHideTriggered: ((Int, String) -> ())
    var backgroundView = UIView()
    var curMatchId: String!
    var curTeamId: String!
    var curTime: String!
    
    init(completeBack: @escaping (Int, String) -> ()) {
        self.onHideTriggered = completeBack
    }
    
    // MARK: WORK WORK VIEW CONTROLLER
    
    public func showWith(matchId: String, teamId: String, time: String, teamTitle: String, defValue: Int) { // TODO modify time
        self.curMatchId = matchId
        self.curTeamId = teamId
        self.curTime = time
        
        self.autoGoalsView.initValues(team: teamTitle, defValue: defValue, callBack: self)
        
        if let window = UIApplication.shared.keyWindow {
            backgroundView.backgroundColor = EventMaker.BACKGROUND_COLOR
            backgroundView.alpha = 0
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(hideBackgroundView))
            )
            
            window.addSubview(backgroundView)
            window.addSubview(autoGoalsView)
            
            autoGoalsView.setCenterFromParent()
            
            backgroundView.frame = window.frame
            
            autoGoalsView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                
                self.autoGoalsView.alpha = 1
            }, completion: nil)
        }
    }
    
    func hide(value: Int) {
        self.hideBackgroundView()
        onHideTriggered(value, curTeamId)
    }
    
    // MARK: HELPERS
    
    @objc func hideBackgroundView() {
        UIView.animate(withDuration: 0.2)
        {
            self.backgroundView.alpha = 0
            self.autoGoalsView.alpha = 0
        }
    }
    
}

extension AutoGoalsMaker: EditAutoGoalsCallBack {
    func complete(value: Int) {
        self.hide(value: value)
    }
}
