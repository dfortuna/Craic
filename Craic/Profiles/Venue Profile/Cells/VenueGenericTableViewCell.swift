//
//  VenueGenericTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 11/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueGenericTableViewCell: UITableViewCell {

    
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var showFeatureIconImageView: UIImageView!
    
    func formatUI(label: String) {
        featureLabel.text = label
        showFeatureIconImageView.image = Icons.tableViewCellArrow
    }
    
}
