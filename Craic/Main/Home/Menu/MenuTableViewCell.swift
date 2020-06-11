//
//  MenuTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconNameImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    func upDateUI(cellName: String) {
        optionLabel.text = cellName
        switch cellName {
        case "Friends":
            iconNameImageView.image = Icons.friends
        case "Favorites":
            iconNameImageView.image = Icons.favorite
        case "Messages":
            iconNameImageView.image = Icons.message
        default:
            break
        }
          
    }
}
