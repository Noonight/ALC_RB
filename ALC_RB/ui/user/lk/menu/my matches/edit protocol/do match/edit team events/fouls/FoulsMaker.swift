//
//  FoulsMaker.swift
//  ALC_RB
//
//  Created by ayur on 09.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

protocol FoulsMakerCallBack {
    
    func addCallBack()
    
}

class FoulsMaker: NSObject {
    static let SIZE = CGRect(x: 0, y: 0, width: 278, height: 153)
    static let BACKGROUND_COLOR = UIColor(white: 0, alpha: 0.1)
    
    let foulsView = EditFoulsView(frame: SIZE)
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
        
        self.foulsView.initValues(team: teamTitle, defValue: defValue, callBack: self)
        
        if let window = UIApplication.shared.keyWindow {
            backgroundView.backgroundColor = EventMaker.BACKGROUND_COLOR
            backgroundView.alpha = 0
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(hideBackgroundView))
            )
            
            window.addSubview(backgroundView)
            window.addSubview(foulsView)
            
            foulsView.setCenterFromParent()
            
            backgroundView.frame = window.frame
            
            foulsView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                
                self.foulsView.alpha = 1
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
            self.foulsView.alpha = 0
        }
    }
    
}

extension FoulsMaker: EditFoulsCallBack {
    func complete(value: Int) {
        self.hide(value: value)
    }
}
