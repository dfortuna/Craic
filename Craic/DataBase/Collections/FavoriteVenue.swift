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
    dynamic var id = ""
    dynamic var venueID = ""
    dynamic var venueName = ""
    dynamic var venueProfilePicture: String = ""
    
    override class func primaryKey() -> String? {
        "venueID"
    }
    
    convenience init(id: String, venueID: String, venueName: String, venueProfilePicture: String){
        self.init()
        self.id = id
        self.venueID = venueID
        self.venueName = venueName
        self.venueProfilePicture = venueProfilePicture
    }
}
