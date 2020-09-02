//
//  UILabel+Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 24/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func dynamicHeight() {
    //text and height constraint need to be set before using this method.
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        
        self.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
