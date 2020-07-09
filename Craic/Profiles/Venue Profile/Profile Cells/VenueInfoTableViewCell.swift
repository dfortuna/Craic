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
    @IBOutlet weak var phoneIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var phoneIconHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var emailIconImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var emailIconHeightContraint: NSLayoutConstraint!
 
    @IBOutlet weak var websiteIconImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var websiteIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var websiteIconHeightContraint: NSLayoutConstraint!

    @IBOutlet weak var addressIconImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressIconBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var addressIconHeightContraint: NSLayoutConstraint!
    
    func formatUI(forVenue venue: Venue) {
        if !venue.phone.isEmpty {
            phoneIconImageView.image = Icons.phone
            phoneLabel.text = venue.phone
        } else {
            phoneLabel.isHidden = true
            phoneIconBottomContraint.constant = 0
            phoneIconHeightContraint.constant = 0
        }
        
        if !venue.email.isEmpty {
            emailIconImageView.image = Icons.email
            emailLabel.text = venue.email
        } else {
            emailLabel.isHidden = true
            emailIconBottomContraint.constant = 0
            emailIconHeightContraint.constant = 0
        }
        
        if !venue.website.isEmpty {
            websiteIconImageView.image = Icons.website
            websiteLabel.text = venue.website
        } else {
            websiteLabel.isHidden = true
            websiteIconBottomContraint.constant = 0
            websiteIconHeightContraint.constant = 0
        }
        
        if !venue.address.isEmpty {
            addressIconImageView.image = Icons.address
            addressLabel.text = venue.address
        } else {
            addressLabel.isHidden = true
            addressIconBottomContraint.constant = 0
            addressIconHeightContraint.constant = 0
        }
    }
}
