//
//  UserCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 18/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell, FIRObjectCell {
    
    var user: User?
    var isFavorite = false
    weak var delegate: FIRCellButtonProtocol?
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var isFavoriteButtonOutlet: UIButton!
    
    @IBAction func isFavoriteButtonAction(_ sender: UIButton) {
        isFavorite = isFavorite == false ? true : false
        setIsFavoriteButtonName()
        delegate?.didTapFollowUserButton(sender: self)
    }
    
    fileprivate func formatProfilePicture(_ loggedUser: User) {
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height / 2
        if let profilePictureURL = URL(string: loggedUser.profileImage) {
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
    
    func formatCellUI(withData cellData: FIRCellInputObj) {
        self.format()
        guard let user = cellData.user else { return }
        self.user = user
        self.isFavorite = user.isFollowing ??  false
        formatProfilePicture(user)
        userNameLabel.text = user.name
        setIsFavoriteButtonName()
    }
}
