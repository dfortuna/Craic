//
//  FriendRequestMessageTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 15/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FriendRequestMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var friendProfileImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendshipInvitationDate: UILabel!
    
    @IBAction func declineInvitation(_ sender: UIButton) {
    }
    
    @IBAction func acceptInvitation(_ sender: UIButton) {
    }
    
    func formatUI(forMessage message: Message) {
        
    }

}
