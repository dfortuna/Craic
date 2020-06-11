//
//  UINavigationController+Extension.swift
//  Project4
//
//  Created by Denis Fortuna on 4/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func configureNavigationController() {
        self.navigationBar.tintColor = Colors.tintColor
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = false
        self.isToolbarHidden = true
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = Colors.mainColor
            navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.tintColor!]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.tintColor!]
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.compactAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            self.navigationBar.barTintColor = Colors.mainColor
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.tintColor!]
            self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:   Colors.tintColor!]
        }
    }
    
    func configureTranparentNavgationBar() {
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.tintColor = .clear
//
//
//
//        self.navigationBar.alpha = 0
//        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
//        self.view.backgroundColor = .clear
    }

}
