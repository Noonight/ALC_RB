//
//  PenaltySeriesTableViewCell.swift
//  ALC_RB
//
//  Created by ayur on 13.08.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

class PenaltySeriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var first_image: UIImageView!
    @IBOutlet weak var second_image: UIImageView!
    @IBOutlet weak var third_image: UIImageView!
    
    public var first: PenaltyState = .none {
        didSet {
            first_image.image = getImage(value: self.first)
        }
    }
    public var second: PenaltyState = .none {
        didSet {
            second_image.image = getImage(value: self.second)
        }
    }
    public var third: PenaltyState = .none {
        didSet {
            third_image.image = getImage(value: self.third)
        }
    }
    
    public func initView(group: GroupPenaltyState) {
        self.first = group.firstItem
        self.second = group.secondItem
        self.third = group.thirdItem
    }
    
    private func getImage(value: PenaltyState) -> UIImage {
        switch value {
        case .success:
            return UIImage(named: "ic_green_circle")!
        case .failure:
            return UIImage(named: "ic_gray_circle")!
        case .none:
            return UIImage(named: "ic_invisible_circle")!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
