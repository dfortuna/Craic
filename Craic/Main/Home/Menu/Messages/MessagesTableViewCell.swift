//
//  MessagesTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageTitleUiLabel: UILabel!    
    @IBOutlet weak var subtitleUILabel: UILabel!
    
    func setUI(messageData: Message){
        if messageData.isRead {
            self.contentView.backgroundColor = .lightGray
        }
        messageTitleUiLabel.text = messageData.title
        subtitleUILabel.text = messageData.subTitle
    }

}
