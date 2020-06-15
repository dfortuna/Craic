//
//  Icons.swift
//  Project4
//
//  Created by Denis Fortuna on 27/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

struct Icons {
    
    private init(){}
    
    //TabBar Icons:
    static let menu = #imageLiteral(resourceName: "menu")
    static let search = #imageLiteral(resourceName: "search")
    static let feed = #imageLiteral(resourceName: "home")
    static let settings = #imageLiteral(resourceName: "settings1")
    
    //Menu Friends:
    static let friends = #imageLiteral(resourceName: "freinds")
    
    //Menu | VenueCell(Add-Remove) Favorite:
    static let favorite = #imageLiteral(resourceName: "favorite")
    
    //Menu | UserProfile Messages:
    static let message = #imageLiteral(resourceName: "messageFill")
    
    //Search Filters:
    static let filters = #imageLiteral(resourceName: "filters")
    
    //VenueProfile Icons:
    static let phone = #imageLiteral(resourceName: "phone")
    static let email = #imageLiteral(resourceName: "email")
    static let website = #imageLiteral(resourceName: "web")
    static let address = #imageLiteral(resourceName: "location")
    
    //UserProfile (Locked):
    static let lockedAccount = #imageLiteral(resourceName: "locked")
    
    //Favorite Button for VenueProfile
    static let itsFavoriteButton = #imageLiteral(resourceName: "favoriteButton")
    static let isntFavoriteButton = #imageLiteral(resourceName: "favoriteButton2")

    // UserCell | UserProfile
    static let follow = #imageLiteral(resourceName: "addFriend")
    
    //UserProfile (add as Friend)
    static let addAsFriend = #imageLiteral(resourceName: "addFriend")
    
    //UserProfile | UserCell (user profile cell not found):
    static let userPictureNotFound = #imageLiteral(resourceName: "userNotFound")
    
    //EventProfile EventCell (event profile picture not found)
    static let eventPictureNotFound = #imageLiteral(resourceName: "eventNotFound")
    
    //VenueProfile VenueCell (venue profile picture not found)
    static let venuePictureNotFound = #imageLiteral(resourceName: "venueNotFound")
    
    //VenueProfile (Galery, Followers, Events cells)
    static let tableViewCellArrow = #imageLiteral(resourceName: "cellArrrow")
    
    //Back button for UserProfile, EventProfile and VenueProfile
    static let backButton = #imageLiteral(resourceName: "backArrow")
}
