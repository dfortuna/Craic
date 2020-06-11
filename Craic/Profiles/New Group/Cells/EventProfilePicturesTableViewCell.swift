//
//  eventProfilePicturesTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 9/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventProfilePicturesTableViewCell: UITableViewCell {

    @IBOutlet weak var eventProfilePicture: UIImageView!
    
    func formatUI(image: [String: String]){
        eventProfilePicture.image = #imageLiteral(resourceName: "Morty.jpg")
    }

}
