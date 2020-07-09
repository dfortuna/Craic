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
    
    weak var delegate: VenueProfileMainCellDelegate?
    var currentVenue: Venue?
    var isFavoriteVenue = false

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var favoriteOutlet: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        delegate?.handleIsFavoriteToggleButton(sender: self)
        setFavoriteButtonImage(isFavoriteVenue)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.handleBackButton(sender: self)
    }
    
    func formatUI(forVenue venue: Venue, isFavorite: Bool) {
        currentVenue = venue
        isFavoriteVenue = isFavorite
        
        nameLabel.text = venue.name
        descriptionLabel.text = venue.description
        descriptionLabel.dynamicHeight()
        
        formatProfileImage(venue)
        formatCoverImage(venue)
        formatCategoryLabel(venue)
        setFavoriteButtonImage(isFavorite)
        formatBackButton()
    }
    
    fileprivate func setFavoriteButtonImage(_ isFavorite: Bool) {
        favoriteOutlet.tintColor = Colors.mainColor
        if isFavorite {
            favoriteOutlet.setBackgroundImage(Icons.itsFavoriteButton, for: .normal)
        } else {
            favoriteOutlet.setBackgroundImage(Icons.isntFavoriteButton, for: .normal)
        }
    }
    
    fileprivate func formatProfilePictureNotFound() {
        DispatchQueue.main.async {
            self.profilePhotoImageView.contentMode = .center
            self.profilePhotoImageView.tintColor = Colors.cellLabelColor
            self.profilePhotoImageView.backgroundColor = Colors.darkBackgroundColor
            self.profilePhotoImageView.image = Icons.venuePictureNotFound
            self.profilePhotoImageView.layer.cornerRadius = 12
        }
    }
    
    fileprivate func formatProfileImage(_ venue: Venue) {
        if let profileImage = URL(string: venue.images["0"] ?? "" ) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: profileImage) {
                    DispatchQueue.main.async {
                        self.profilePhotoImageView.image = UIImage(data: imageData)
                        self.profilePhotoImageView.backgroundColor = Colors.tintColor
                        self.profilePhotoImageView.layer.cornerRadius = 12
                    }
                } else {
                    self.formatProfilePictureNotFound()
                }
            }
        } else {
            formatProfilePictureNotFound()
        }
    }
    
    fileprivate func formatCoverImage(_ venue: Venue) {
        if let coverImage = URL(string: venue.images["1"] ?? "" ) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: coverImage)  else { return }
                DispatchQueue.main.async {
                    self.coverPhotoImageView.image = UIImage(data: imageData)
                    self.coverPhotoImageView.contentMode = .scaleToFill
                }
            }
        } else {
            coverPhotoImageView.contentMode = .scaleAspectFit
            coverPhotoImageView.tintColor = Colors.cellLabelColor
            coverPhotoImageView.backgroundColor = Colors.darkBackgroundColor
            coverPhotoImageView.image = Icons.venuePictureNotFound
            coverPhotoImageView.contentMode = .center
        }
    }
    
    fileprivate func formatCategoryLabel(_ venue: Venue) {
        categoryLabel.text = venue.category
        categoryLabel.layer.borderWidth = 0.8
        categoryLabel.layer.borderColor = Colors.mainColor?.cgColor
        categoryLabel.textColor = Colors.mainColor
    }
    
    fileprivate func formatBackButton() {
        backButtonOutlet.layer.cornerRadius = 15
        backButtonOutlet.backgroundColor = Colors.lightBackgroundColor
        backButtonOutlet.tintColor = Colors.darkBackgroundColor
    }
}
