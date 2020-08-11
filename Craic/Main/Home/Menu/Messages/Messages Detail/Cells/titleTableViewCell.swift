//
//  titleTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 29/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class titleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var messageTitle: String?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    func formatUI(title: String, isAThread: Bool) {
        
        let t = title == "" ? "No title" : title
        titleLabel.text = isAThread ? "Re: \(t)" : t
        messageTitle = isAThread ? "Re: \(t)" : t
    }
}
