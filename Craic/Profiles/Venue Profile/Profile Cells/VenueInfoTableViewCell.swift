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
    @IBOutlet weak var phoneIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var PhoneLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailIconImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var websiteIconImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var webSiteLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var websiteIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webSiteSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressIconImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var AddressSpacingConstraint: NSLayoutConstraint!
    
    func formatUI(forVenue venue: Venue) {
        if !venue.phone.isEmpty {
            phoneIconImageView.image = Icons.phone
            phoneLabel.text = venue.phone
        } else {
            phoneIconHeightConstraint.constant = 0
            PhoneLabelHeightConstraint.constant = 0
            phoneSpacingConstraint.constant = 0
        }
        
        if !venue.email.isEmpty {
            emailIconImageView.image = Icons.email
            emailLabel.text = venue.email
        } else {
            emailLabelHeightConstraint.constant = 0
            emailIconHeightConstraint.constant = 0
            emailSpacingConstraint.constant = 0
        }
        
        if !venue.website.isEmpty {
            websiteIconImageView.image = Icons.website
            websiteLabel.text = venue.website
        } else {
            webSiteLabelHeightConstraint.constant = 0
            websiteIconHeightConstraint.constant = 0
            webSiteSpacingConstraint.constant = 0
        }
        
        if !venue.address.isEmpty {
            addressIconImageView.image = Icons.address
            addressLabel.text = venue.address
        } else {
            addressLabelHeightConstraint.constant = 0
            addressIconHeightConstraint.constant = 0
            AddressSpacingConstraint.constant = 0
        }
    }
}
