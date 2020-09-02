//
//  SelectFriendsTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 11/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class SelectFriendsTableViewCell: UITableViewCell {

    var selectedUser: User?
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSelectedImageView: UIImageView!
    
    func formatUI(user: User, isSelected: Bool) {
        selectedUser = user
        userNameLabel.text = user.name
        formatProfilePicture(forUrl: user.profileImage)
        
        if isSelected {
            userSelectedImageView.image =  Icons.selected
        } else {
            userSelectedImageView.image =  Icons.notSelected
        }
    }
    
    private func formatProfilePicture(forUrl stringURL: String) {
        userProfilePicture.layer.cornerRadius = 30
        if let profilePictureURL = URL(string: stringURL) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: profilePictureURL)  else { return }
                DispatchQueue.main.async {
                    self.userProfilePicture.image = UIImage(data: imageData)
                }
            }
        } else {
            userProfilePicture.image = Icons.userPictureNotFound
        }
    }
}
