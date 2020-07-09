//
//  UITextView+Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 30/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func dynamicHeight() {
    //TextView text and height constraint need to be set before using this method.
        self.isScrollEnabled = false
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        
        self.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
