//
//  TournamentTeamHeaderView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 01/08/2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TournamentTeamHeaderView: UIView {
    static let HEIGHT = 37
    
    @IBOutlet var container_view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("TournamentTeamHeaderView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
