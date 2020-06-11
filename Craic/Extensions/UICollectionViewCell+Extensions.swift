//
//  UICollectionViewCell+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 5/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func format() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.contentView.layer.borderWidth = 0.8
    }
}
