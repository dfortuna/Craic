//
//  VenueCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 2/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol VenueCollectionViewCellProtocol: class {
    func handleAddAsFavorite(sender:VenueCollectionViewCell)
}

class VenueCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: VenueCollectionViewCellProtocol?
    var currentVenue: Venue?
    var isFavorite = false
    
    @IBOutlet weak var venueProfileImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addFavoriteButtonOutlet: UIButton!
    
    @IBAction func addFavoriteUIButton(_ sender: Any) {
        isFavorite = isFavorite == false ? true : false
        setFollowingButtonName()
        delegate?.handleAddAsFavorite(sender: self)
    }
    
    fileprivate func formatProfilePicture(_ venue: Venue) {
        venueProfileImageView.image = Icons.venuePictureNotFound
        venueProfileImageView.backgroundColor = Colors.darkBackgroundColor
        venueProfileImageView.tintColor = Colors.cellLabelColor
        venueProfileImageView.contentMode = .center
        if let profilePicString = venue.images["0"] {
            if let profImage = URL(string: profilePicString) {
                DispatchQueue.global().async {
                    guard let imagedata2 = try? Data(contentsOf: profImage)  else { return }
                    DispatchQueue.main.async {
                        self.venueProfileImageView.image = UIImage(data: imagedata2)
                        self.venueProfileImageView.backgroundColor = nil
                        self.venueProfileImageView.contentMode = .scaleAspectFill
                    }
                }
            }
        }
    }
    
    fileprivate func setFollowingButtonName() {
        if isFavorite {
            addFavoriteButtonOutlet.formatCustomButtonEnabled(forTitle: "Following")
        } else {
            addFavoriteButtonOutlet.formatCustomButtonDisabled(forTitle: "Follow")
        }
    }
    
    func formatUI(venue: Venue, isFavorite: Bool){
        self.format()
        currentVenue = venue
        venueNameLabel.attributedText = formatLabel(labelText: venue.name)
        formatProfilePicture(venue)
        
//        self.isFavorite = isFavorite
        self.isFavorite = true
        setFollowingButtonName()
    }
    
    fileprivate func formatLabel(labelText: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeWidth: -5.0,
                                                         .font: UIFont.boldSystemFont(ofSize: 25)]
        let attributedQuote = NSAttributedString(string: labelText, attributes: attributes)
        return attributedQuote
    }
}
