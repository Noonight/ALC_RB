//
//  MatchProtocolViewController.swift
//  ALC_RB
//
//  Created by ayur on 16.01.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class MatchProtocolViewController: UIViewController {

    @IBOutlet weak var teamOneLogo: UIImageView!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var teamOneBtn: UIButton!
    
    @IBOutlet weak var teamTwoLogo: UIImageView!
    @IBOutlet weak var teamTwoTitle: UILabel!
    @IBOutlet weak var teamTwoBtn: UIButton!
    
    @IBOutlet weak var responsiblePersonsBtn: UIButton!
    
    @IBOutlet weak var eventsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        title = "Протокол"
    }
}
