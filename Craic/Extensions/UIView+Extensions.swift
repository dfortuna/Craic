//
//  UIView+Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 22/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func anchorEdges(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                     right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                     padding: UIEdgeInsets) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: padding.right).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
    }
    
    
    func anchorCenters(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func anchorSizes(sizeWidth: CGFloat?, sizeHeight: CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let sizeWidth = sizeWidth {
            self.widthAnchor.constraint(equalToConstant: sizeWidth).isActive = true
        }
        if let sizeHeight = sizeHeight {
            self.heightAnchor.constraint(equalToConstant: sizeHeight).isActive = true
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.borderWidth = 1
        mask.borderColor = UIColor.black.cgColor
        layer.mask = mask
     }
}
