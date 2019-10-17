//
//  MyTourneyHeaderView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class MyTourneyHeaderView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19)
        label.numberOfLines = 3
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
//        label.textColor = UIColor.lightGray
        
        return label
    }()
    private let disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        let image = #imageLiteral(resourceName: "ic_arrow_right")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.isHidden = true
        
        return imageView
    }()
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    var action : ((TourneyModelItem) -> ())? {
        didSet {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnView)))
        }
    }
    var separatorColor: UIColor? {
        didSet {
            bottomSeparatorView.backgroundColor = self.separatorColor
        }
    }
    var tourneyModelItem: TourneyModelItem! {
        didSet {
            if let first = tourneyModelItem.leagues?.first {
                self.nameLabel.text = self.tourneyModelItem.name ?? "" + " ." + (first.name ?? "")
                self.dateLabel.text = (first.beginDate ?? "") + " - " + (first.endDate ?? "")
            } else {
                self.nameLabel.text = self.tourneyModelItem.name
                self.dateLabel.text = (self.tourneyModelItem.beginDate ?? "") + " - " + (self.tourneyModelItem.endDate ?? "")
            }
        }
    }
    var isDisclosure = false {
        didSet {
            if self.isDisclosure == true {
                self.disclosureImageView.isHidden = false
            } else {
                self.disclosureImageView.isHidden = true
            }
        }
    }
    
    func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(disclosureImageView)
        addSubview(bottomSeparatorView)
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: 8).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: 8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
//        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        
        disclosureImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        disclosureImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func tapOnView() {
        self.action?(self.tourneyModelItem)
        let transformerStart = CGAffineTransform(scaleX: 0.98, y: 0.98)
        let transformerEnd = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        layoutIfNeeded()
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = transformerStart
        }) { completed in
            if completed {
                UIView.animate(withDuration: 0.1) {
                    self.transform = transformerEnd
                }
            } else {
                Print.m("completed = \(completed)")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}