//
//  VenueInfoTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 11/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneIconImageView: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailIconImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var websiteIconImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var addressIconImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    func formatUI(forVenue venue: Venue) {
        phoneIconImageView.image = Icons.phone
        phoneLabel.text = venue.phone
    
        emailIconImageView.image = Icons.email
        emailLabel.text = venue.email
        
        websiteIconImageView.image = Icons.website
        websiteLabel.text = venue.website
        
        addressIconImageView.image = Icons.address
        addressLabel.text = venue.address
    }
    
    
}
