//
//  CallendarView.swift
//  Craic
//
//  Created by Denis Fortuna on 28/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

class CallendarView: UIView {
    
    private var container1 = UIView()
    private var monthView = UIView()
    private var monthLabel = UILabel()
    private var dayView = UIView()
    private var dayLabel = UILabel()
    
    func formatUI(day: String, month: String) {
        self.dayLabel.text = day
        self.monthLabel.text = month
        format()
    }
    
    private func format(){
        self.addSubview(container1)
        container1.anchorEdges(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, padding: .zero)
        container1.backgroundColor = .white
        
        
        container1.addSubview(monthView)
        monthView.anchorEdges(top: container1.topAnchor, left: container1.leftAnchor, right: container1.rightAnchor, bottom: nil, padding: .zero)
        monthView.anchorSizes(sizeWidth: nil, sizeHeight: 24)
        monthView.backgroundColor = .red
        
        
        monthView.addSubview(monthLabel)
        monthLabel.anchorCenters(centerX: monthView.centerXAnchor, centerY: monthView.centerYAnchor)
        monthLabel.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue",size: 15.0) as Any]
        monthLabel.attributedText = NSAttributedString(string: "Jun",
                                                     attributes: attributes)
        
        container1.addSubview(dayView)
        dayView.anchorEdges(top: monthView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, padding: .zero)


        dayView.addSubview(dayLabel)
        dayLabel.anchorCenters(centerX: dayView.centerXAnchor, centerY: dayView.centerYAnchor)
        dayLabel.textColor = .black
        let attributes2: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue",size: 30.0) as Any]
        dayLabel.attributedText = NSAttributedString(string: "28",
                                                     attributes: attributes2)
    }
}
