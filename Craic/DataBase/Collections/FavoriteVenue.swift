//
//  FavoriteVenues.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class FavoriteVenue: Object {
    dynamic var venueID = ""
    dynamic var venueName = ""
    dynamic var venueProfilePicture: String = ""
    
    override class func primaryKey() -> String? {
        "venueID"
    }
    
    convenience init(venueID: String, venueName: String, venueProfilePicture: String){
        self.init()
        self.venueID = venueID
        self.venueName = venueName
        self.venueProfilePicture = venueProfilePicture
    }
}
