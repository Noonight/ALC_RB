//
//  ProtocolAllTableEventsCell.swift
//  ALC_RB
//
//  Created by ayur on 05.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit
 // protocol_table_all_cell
class ProtocolAllTableEventsCell: UITableViewCell {

    @IBOutlet weak var left_name_label: UILabel!
    @IBOutlet weak var left_event_image: UIImageView!
    @IBOutlet weak var right_event_image: UIImageView!
    @IBOutlet weak var right_name_label: UILabel!
    
    var cellModel: ProtocolAllEventsCellModel? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        resetUI()
        
        if cellModel?.left_name == ""
        {
            left_name_label.isHidden = true
        }
        if cellModel?.left_event == .non
        {
            left_event_image.isHidden = true
        }
        if cellModel?.right_name == ""
        {
            right_name_label.isHidden = true
        }
        if cellModel?.right_event == .non
        {
            right_event_image.isHidden = true
        }
        
        setupUI()
    }
    
    private func setupUI() {
        left_name_label.text = cellModel?.left_name
        left_event_image.image = cellModel?.left_event.getImage()
        
        right_name_label.text = cellModel?.right_name
        right_event_image.image = cellModel?.right_event.getImage()
    }
    
    private func resetUI() {
        left_name_label.isHidden = false
        left_event_image.isHidden = false
        
        right_name_label.isHidden = false
        right_event_image.isHidden = false
    }
    
}
