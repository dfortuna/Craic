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
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    weak var delegate: VenueProfileMainCellDelegate?
    var currentVenue: Venue?
    var isFavoriteVenue = false
    
    fileprivate func formatProfilePictureNotFound() {
        DispatchQueue.main.async {
            self.profilePhotoImageView.contentMode = .center
            self.profilePhotoImageView.tintColor = Colors.cellLabelColor
            self.profilePhotoImageView.backgroundColor = Colors.darkBackgroundColor
            self.profilePhotoImageView.image = Icons.venuePictureNotFound
            self.profilePhotoImageView.layer.cornerRadius = 12
        }
    }
    
    func formatUI(forVenue venue: Venue, isFavorite: Bool) {
        currentVenue = venue
        isFavoriteVenue = isFavorite
        
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

        if let coverImage = URL(string: venue.images["1"] ?? "" ) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: coverImage)  else { return }
                DispatchQueue.main.async {
                    self.coverPhotoImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            coverPhotoImageView.contentMode = .scaleAspectFit
            coverPhotoImageView.tintColor = Colors.cellLabelColor
            coverPhotoImageView.backgroundColor = Colors.darkBackgroundColor
            coverPhotoImageView.image = Icons.venuePictureNotFound
            coverPhotoImageView.contentMode = .center
            
        }
        
        nameLabel.text = venue.name
        categoryLabel.text = venue.category
        categoryLabel.layer.borderWidth = 0.8
        categoryLabel.layer.borderColor = Colors.mainColor?.cgColor
        categoryLabel.textColor = Colors.mainColor
        descriptionLabel.text = venue.description
        
        favoriteOutlet.tintColor = Colors.mainColor
        setFavoriteButtonImage(isFavorite)
        
        backButtonOutlet.layer.cornerRadius = 15
        backButtonOutlet.backgroundColor = Colors.lightBackgroundColor
        backButtonOutlet.tintColor = Colors.darkBackgroundColor
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
