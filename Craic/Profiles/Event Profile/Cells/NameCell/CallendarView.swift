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
    private var dayString = String()
    private var monthString = String()
    
    func formatUI(day: String, month: String) {
        self.dayString = day
        self.monthString = month
        configureContainer()
        configureMonthView()
        configureMonthLabel()
        configureDayView()
        configureDayLabel()
    }
    
    fileprivate func configureContainer() {
        self.addSubview(container1)
        container1.anchorEdges(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, padding: .zero)
        container1.backgroundColor = .white
    }
    
    fileprivate func configureMonthView() {
        container1.addSubview(monthView)
        monthView.anchorEdges(top: container1.topAnchor, left: container1.leftAnchor, right: container1.rightAnchor, bottom: nil, padding: .zero)
        monthView.anchorSizes(sizeWidth: nil, sizeHeight: 24)
        monthView.backgroundColor = .red
    }
    
    fileprivate func configureMonthLabel() {
        monthView.addSubview(monthLabel)
        monthLabel.anchorCenters(centerX: monthView.centerXAnchor, centerY: monthView.centerYAnchor)
        monthLabel.textColor = .white
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue",size: 15.0) as Any]
        monthLabel.attributedText = NSAttributedString(string: monthString,
                                                       attributes: attributes)
    }
    
    fileprivate func configureDayView() {
        container1.addSubview(dayView)
        dayView.anchorEdges(top: monthView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, padding: .zero)
    }
    
    fileprivate func configureDayLabel() {
        dayView.addSubview(dayLabel)
        dayLabel.anchorCenters(centerX: dayView.centerXAnchor, centerY: dayView.centerYAnchor)
        dayLabel.textColor = .black
        let attributes2: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue",size: 30.0) as Any]
        dayLabel.attributedText = NSAttributedString(string: dayString,
                                                     attributes: attributes2)
    }
}
