//
//  HorizontalDisplayCollectionViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 25/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class HorizontalDisplayCollectionViewCell: UICollectionViewCell {
    
    private var profileImage = UIImageView()
        
    func formatUI(picture: String) {
        configureImageView()
        loadImage(picture)
    }
    
    fileprivate func configureImageView() {
        self.addSubview(profileImage)
        profileImage.anchorEdges(top: self.topAnchor,
                                 left: self.leftAnchor,
                                 right: self.rightAnchor,
                                 bottom: self.bottomAnchor, padding: .zero)
    }
    
    fileprivate func loadImage(_ picture: String) {
        if let profileImage = URL(string: picture) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: profileImage) {
                    DispatchQueue.main.async {
                        self.profileImage.image = UIImage(data: imageData)
                        self.profileImage.backgroundColor = Colors.tintColor
                        self.profileImage.contentMode = .scaleToFill
                    }
                } else {
                    self.formatProfilePictureNotFound()
                }
            }
        } else {
            formatProfilePictureNotFound()
        }
    }
    
    fileprivate func formatProfilePictureNotFound() {
        DispatchQueue.main.async {
            self.profileImage.contentMode = .center
            self.profileImage.tintColor = Colors.cellLabelColor
            self.profileImage.backgroundColor = Colors.darkBackgroundColor
            self.profileImage.image = Icons.venuePictureNotFound
        }
    }
}
