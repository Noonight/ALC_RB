//
//  TeamsLeagueDetail.swift
//  ALC_RB
//
//  Created by ayur on 17.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class TeamsLeagueDetailTabBarController: UITabBarController {

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y + 100
        self.tabBar.frame = tabFrame
    }
    
    override func viewDidLayoutSubviews() {
        
        
        super.viewDidLayoutSubviews()
    }

}
