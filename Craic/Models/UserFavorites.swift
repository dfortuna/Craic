//
//  UserFavorites.swift
//  Craic
//
//  Created by Denis Fortuna on 10/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct UserFavorites: FIRObjectProtocol {
    
    //document id on databas
    var id: String
    
    //User data(used for the venue to send posts to users feed
    var userID: String
    var userName: String
    var userProfilePicture: String
    
    //Venue data(used for the user to lits favorite venues
    var venueID: String
    var venueName: String
    var venueProfilePicture: String
    var isFavorite: Bool
    
    init?(with dictionary: [String : AnyObject]) {
        
        if let venueId = dictionary["id"] as? String, venueId != "" {
            self.id = venueId
            
            self.userID = dictionary["userID"] as? String ?? ""
            self.userName = dictionary["userName"] as? String ?? ""
            self.userProfilePicture = dictionary["userProfilePicture"] as? String ?? ""
            
            self.venueID = dictionary["venueID"] as? String ?? ""
            self.venueName = dictionary["venueName"] as? String ?? ""
            self.venueProfilePicture = dictionary["venueProfilePicture"] as? String ?? ""
            self.isFavorite = true
        } else {
            print("Favorite Venue obj not created - id not valid")
            return nil
        }
    }
    
    init(forUser user: User, andVenue venue: Venue) {
        self.id = UUID().uuidString
        self.userID = user.id
        self.userName = user.name
        self.userProfilePicture = user.profileImage
        self.venueID = venue.id
        self.venueName = venue.name
        self.isFavorite = true
        self.venueProfilePicture = venue.images["0"] ?? ""
    }
    
    func getFavoriteVenue() -> Venue? {
        Venue(with:  ["id": venueID,
                      "name": venueName,
                      "isFavorite": isFavorite,
                      "images": ["0": venueProfilePicture]] as [String: AnyObject])
    }
    
    func getUser() -> User? {
        User(with:  ["id": userID,
                      "name": userName,
                      "profileImage": userProfilePicture] as [String: AnyObject])
    }
}
