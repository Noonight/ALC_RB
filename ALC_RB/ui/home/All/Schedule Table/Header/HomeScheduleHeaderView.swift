//
//  HomeScheduleHeaderView.swift
//  ALC_RB
//
//  Created by mac on 20.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class HomeScheduleHeaderView: UIView {

    @IBOutlet var container_view: HomeScheduleHeaderView!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var place_label: UILabel!
    
    var date: String = "" {
        didSet {
            date_label.text = self.date
        }
    }
    var place: String = "" {
        didSet {
            place_label.text  = self.place
        }
    }
    var played: Bool = false  {
        didSet {
            if played == true
            {
                place_label.textColor = .red 
            }
            else
            {
                place_label.textColor = .green
            }
        }
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
        Bundle.main.loadNibNamed("HomeScheduleHeaderView", owner: self, options: nil)
        addSubview(container_view)
        container_view.frame = self.bounds
        container_view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
