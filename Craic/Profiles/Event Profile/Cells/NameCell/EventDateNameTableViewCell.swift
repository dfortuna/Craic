//
//  EventDateNameTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 24/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol eventProfileNameCellProtocol: class {
    func showHost(sender: EventDateNameTableViewCell)
}

class EventDateNameTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarView: CallendarView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var hostButtonOutlet: UIButton!
    weak var delegate: eventProfileNameCellProtocol?
    
    @IBAction func hostButton(_ sender: UIButton) {
        self.delegate?.showHost(sender: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    func formatUI(name: String, date: String, hostName: String) {
        
        calendarView.layer.cornerRadius = 10
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.black.cgColor
        
        eventNameLabel.text = name
        hostButtonOutlet.setTitle(hostName, for: .normal)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        guard let dateFormat = formatter.date(from: date) else { return }
        
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: dateFormat)
        
        formatter.dateFormat = "dd"
        let day = formatter.string(from: dateFormat)
        
        calendarView.formatUI(day: day, month: month)
    }
    
}
