//
//  HomeAnnounceTableViewCell.swift
//  ALC_RB
//
//  Created by mac on 23.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class HomeAnnounceTableViewCell: UITableViewCell {

    @IBOutlet weak var content_label: UILabel!
    
    var first: Bool = false  {
        didSet {
            if self.first == true
            {
                self.backgroundColor = .yellow
            }
            else
            {
                self.backgroundColor = .white
            }
        }
    }
    
    var content: String = "" {
        didSet {
            self.content_label.text = self.content
        }
    }
    
}
