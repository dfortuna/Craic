//
//  EventDateNameTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 24/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventDateNameTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarView: CallendarView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    func formatUI() {
        calendarView.formatUI(day: "28", month: "Jun")
        calendarView.layer.cornerRadius = 10
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.black.cgColor
    }
    
}
