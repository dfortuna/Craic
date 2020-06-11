//
//  UserCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 18/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol UserCollectionViewCellProtocol: class {
    func handleFavoriteToggle(sender: UserCollectionViewCell)
}

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var isFavoriteButtonOutlet: UIButton!
    var friend: Friend?
    var isFavorite = false
    weak var delegate: UserCollectionViewCellProtocol?
    
    @IBAction func isFavoriteButtonAction(_ sender: UIButton) {
        isFavorite = isFavorite == false ? true : false
        setIsFavoriteButtonName()
        delegate?.handleFavoriteToggle(sender: self)
    }
    
    fileprivate func formatProfilePicture(_ friendData: Friend) {
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height / 2
        if let profilePictureURL = URL(string: friendData.profilePic) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: profilePictureURL)  else { return }
                DispatchQueue.main.async {
                    self.userProfilePictureImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            userProfilePictureImageView.image = Icons.userPictureNotFound
        }
    }
    
    fileprivate func setIsFavoriteButtonName() {
        if isFavorite {
            isFavoriteButtonOutlet.formatCustomButtonEnabled(forTitle: "Following")
        } else {
            isFavoriteButtonOutlet.formatCustomButtonDisabled(forTitle: "Follow")
        }
    }
    
    func formatUI(friendData: Friend, isFavorite: Bool) {
        self.format()
        friend = friendData
        self.isFavorite = isFavorite
        
        formatProfilePicture(friendData)
        userNameLabel.text = friendData.name
        
        setIsFavoriteButtonName()
        print("%%%%% CELL", self.bounds.height)
        print("")
    }
}
