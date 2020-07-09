//
//  EventInfoTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 29/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var timeIconHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var phoneIconHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var priceIconHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var addressIconHeightContraint: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    func formatUI(time: String, phone: String, price: String, address: String ) {
        if !time.isEmpty {
            timeLabel.text = time
        } else {
            timeLabel.isHidden = true
            timeIconBottomContraint.constant = 0
            timeIconHeightContraint.constant = 0
        }
        
        if !phone.isEmpty {
            phoneLabel.text = phone
        } else {
            phoneLabel.isHidden = true
            phoneIconBottomContraint.constant = 0
            phoneIconHeightContraint.constant = 0
        }
        
        if !price.isEmpty {
            priceLabel.text = price
        } else {
            priceLabel.isHidden = true
            priceIconBottomContraint.constant = 0
            priceIconHeightContraint.constant = 0
        }
        
        if !address.isEmpty {
            addressLabel.text = address
        } else {
            addressLabel.isHidden = true
            addressIconBottomContraint.constant = 0
            addressIconHeightContraint.constant = 0
        }
    }

}
