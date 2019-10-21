//
//  InsideTourneysVC.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 21.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class InsideTourneysVC: UIViewController {

    static func getInstance() -> InsideTourneysVC {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//
//        let viewController = storyboard.instantiateViewController(withIdentifier: "InsideTourneysVC") as! InsideTourneysVC
        
        return InsideTourneysVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
