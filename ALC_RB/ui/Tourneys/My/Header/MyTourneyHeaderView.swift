//
//  MyTourneyHeaderView.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 16.10.2019.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

final class MyTourneyHeaderView: UIView {
    
    // MARK: - VIEWS
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
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
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.setTitle("Удалить", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()
    
    // MARK: - VARIABLES
    
    var deleteAction : ((TourneyModelItem) -> ())? {
        didSet {
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnDelete)))
        }
    }
    // MARK: -
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
            if tourneyModelItem.leagues?.count ?? 0 == 1 {
                if let first = tourneyModelItem.leagues?.first {
                    self.nameLabel.text = "\(tourneyModelItem.name ?? ""). \(first.name ?? "")"
                    self.dateLabel.text = (first.beginDate ?? "") + " - " + (first.endDate ?? "")
                }
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
    // MARK: - GESTURE
    
    var containerLeftAnchor: NSLayoutConstraint?
    var containerRightAnchor: NSLayoutConstraint?
    
    // MARK: - INIT VIEW
    
    func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        containerLeftAnchor = containerView.leftAnchor.constraint(equalTo: leftAnchor)
        containerLeftAnchor?.isActive = true
        containerRightAnchor = containerView.rightAnchor.constraint(equalTo: rightAnchor)
        containerRightAnchor?.isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(bottomSeparatorView)
        
        bottomSeparatorView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        addSubview(deleteButton)
        
        deleteButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: 0).isActive = true
        
        bringSubviewToFront(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(disclosureImageView)
        
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: 8).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: 8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8).isActive = true
        
        disclosureImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        disclosureImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        containerView.backgroundColor = .blue
        
        
        bringSubviewToFront(containerView)
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        left.direction = .left
        containerView.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        right.direction = .right
        containerView.addGestureRecognizer(right)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ACTIONS
    
    var startPoint: CGPoint?
    var startingRightConst: CGFloat?
    
    @objc func panGesture(_ sender: UISwipeGestureRecognizer) {
//        switch sender.state {
//        case .began:
//            self.startPoint = sender.translation(in: self.containerView)
//            self.startingRightConst = self.containerRightAnchor?.constant
//            break;
//        case .changed:
//            var currentPoint = sender.translation(in: self.containerView)
//            var deltaX = currentPoint.x - self.startPoint!.x
//            var panningLeft = false
//
//            if currentPoint.x < self.startPoint!.x {
//                panningLeft = true
//            }
//            if startingRightConst == 0 {
//                if !panningLeft {
//                    var constant = max(-deltaX, 0)
//                    if constant == 0 {
//                        hideButtons()
//                    } else {
//                        UIView.animate(withDuration: 0.1) {
//                            self.containerRightAnchor?.constant = constant
//                        }
//                    }
//                } else {
//                    var constant = min(-deltaX, 100)
//                    if constant == 100 {
//                        showButtons()
//                    } else {
//                        self.containerRightAnchor?.constant = constant
//                    }
//                }
//            } else {
//                var adjustment = self.startingRightConst! - deltaX
//                if !panningLeft {
//                    var constant = max(adjustment, 0)
//                    if constant == 0 {
//                        hideButtons()
//                    } else {
//                        self.containerRightAnchor?.constant = constant
//                    }
//                } else {
//                    var constant = min(adjustment, 100)
//                    if constant == 100 {
//                        showButtons()
//                    } else {
//                        self.containerRightAnchor!.constant = constant
//                    }
//                }
//            }
//
//            self.containerLeftAnchor!.constant = -self.containerRightAnchor!.constant
//            break
//        case .ended:
////            if self.startingRightConst == 0 {
////                var half = 25
////                if Int(containerRightAnchor!.constant) >= half {
////                    showButtons()
////                } else {
////                    hideButtons()
////                }
////            } else {
////                var totalSize = 50
////                if Int(containerRightAnchor!.constant) >= totalSize {
////                    showButtons()
////                } else {
////                    hideButtons()
////                }
////            }
//            break
//        case .cancelled:
//            if startingRightConst == 0 {
//                hideButtons()
//            } else {
//                showButtons()
//            }
//            break
//        case .possible:
//            Print.m("possible")
//            break
//        case .failed:
//            Print.m("failed")
//            break
//        }
        switch sender.direction {
        case .left:
            Print.m("left gesture")
            layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.containerRightAnchor?.constant = -100
                self.containerLeftAnchor?.constant = -100
                self.layoutIfNeeded()
            }
        case .right:
            Print.m("right gesture")
            layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.containerRightAnchor?.constant = 0
                self.containerLeftAnchor?.constant = 0
                self.layoutIfNeeded()
            }
        default:
            Print.m("not left and right")
        }
    }
    
    func hideButtons() {
        if startingRightConst == 0 && containerRightAnchor!.constant == 0 {
            return
        }
        
        updateView(animated: true) {
            self.containerRightAnchor!.constant = 0
            self.containerLeftAnchor!.constant = 0
        }
    }
    
    func showButtons() {
        if startingRightConst == 100 && containerRightAnchor?.constant == 100 {
            return
        }
        
        updateView(animated: true) {
            self.containerLeftAnchor!.constant = -100
            self.containerRightAnchor!.constant = -100
        }
    }
    
    func updateView(animated: Bool, complete: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
            complete()
        }) { completed in
            complete()
        }
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
    
    @objc func tapOnDelete() {
        self.deleteAction?(self.tourneyModelItem)
    }
}
