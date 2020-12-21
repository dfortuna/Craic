//
//  UIButton+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 13/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func formatCustomButtonEnabled(forTitle title: String){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.8
        self.layer.borderColor = Colors.mainColor?.cgColor
        self.setTitleColor(Colors.tintColor, for: .normal)
        self.backgroundColor = Colors.mainColor
        self.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22.0)
        self.setTitle("  \(title)  ", for: .normal)
    }
    
    func formatCustomButtonDecline(forTitle title: String){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.8
        self.layer.borderColor = Colors.mainColor?.cgColor
        self.setTitleColor(Colors.tintColor, for: .normal)
        self.backgroundColor = .red
        self.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22.0)
        self.setTitle("  \(title)  ", for: .normal)
    }
    
    func formatCustomButtonDisabled(forTitle title: String){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        self.layer.borderColor = Colors.mainColor?.cgColor
        self.setTitleColor(Colors.mainColor, for: .normal)
        self.backgroundColor = Colors.tintColor
        self.titleLabel?.font = UIFont(name: "Avenir-Black", size: 22.0)
        self.setTitle("  \(title)  ", for: .normal)
    }
}
