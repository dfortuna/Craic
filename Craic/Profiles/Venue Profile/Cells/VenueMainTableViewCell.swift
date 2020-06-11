//
//  VenueMainTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 11/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol VenueProfileMainCellDelegate: class {
    func handleIsFavoriteToggleButton(sender: VenueMainTableViewCell)
    func handleBackButton(sender: VenueMainTableViewCell)
}

class VenueMainTableViewCell: UITableViewCell {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var favoriteOutlet: UIButton!
    
    weak var delegate: VenueProfileMainCellDelegate?
    var currentVenue: Venue?
    var isFavoriteVenue = false
    
    func formatUI(forVenue venue: Venue, isFavorite: Bool) {
        currentVenue = venue
        isFavoriteVenue = isFavorite
        
        if let profileImage = URL(string: venue.images["0"] ?? "" ) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: profileImage)  else { return }
                DispatchQueue.main.async {
                    self.profilePhotoImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            profilePhotoImageView.image = Icons.userPictureNotFound
        }

        if let coverImage = URL(string: venue.images["1"] ?? "" ) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: coverImage)  else { return }
                DispatchQueue.main.async {
                    self.coverPhotoImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            coverPhotoImageView.image = Icons.venuePictureNotFound
        }
        
        nameLabel.text = venue.name
        categoryLabel.text = venue.category
        categoryLabel.layer.borderWidth = 0.8
        categoryLabel.layer.borderColor = Colors.mainColor?.cgColor
        categoryLabel.textColor = Colors.mainColor
        descriptionLabel.text = venue.description
        
        favoriteOutlet.tintColor = Colors.mainColor
        setFavoriteButtonImage(isFavorite)
    }
    
    fileprivate func setFavoriteButtonImage(_ isFavorite: Bool) {
        if isFavorite {
            favoriteOutlet.setBackgroundImage(Icons.itsFavoriteButton, for: .normal)
        } else {
            favoriteOutlet.setBackgroundImage(Icons.isntFavoriteButton, for: .normal)
        }
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        delegate?.handleIsFavoriteToggleButton(sender: self)
        setFavoriteButtonImage(isFavoriteVenue)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.handleBackButton(sender: self)
    }
}
