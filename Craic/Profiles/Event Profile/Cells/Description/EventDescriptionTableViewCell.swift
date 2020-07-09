//
//  EventDescriptionTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 24/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextView: UITextView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    func formatUI(description: String) {
        descriptionTextView.text = description
        descriptionTextView.dynamicHeight()
    }
}
