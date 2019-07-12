//
//  View.swift
//  ALC_RB
//
//  Created by ayur on 11.07.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    func fixInView(_ container: UIView!) -> Void{
        //        self.translatesAutoresizingMaskIntoConstraints = true;
        //        self.frame = container.frame;
        container.addSubview(self)
        
        container.translatesAutoresizingMaskIntoConstraints = true
        translatesAutoresizingMaskIntoConstraints = true
        //        container.leftAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>)
        //        self.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        //        self.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        //        self.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        //        self.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        //        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        //        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        //        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        //        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
