//
//  UIView+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 21/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setAlphaGradientBackgroundColor(forColor color:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = bounds
        gradientLayer.colors = [color.withAlphaComponent(1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.layer.mask = gradientLayer
    }
}
