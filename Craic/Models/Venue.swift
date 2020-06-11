//
//  Venue.swift
//  Project4
//
//  Created by Denis Fortuna on 12/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct Venue: FIRObjectProtocol {
    var id: String
    
    //Main
    var name: String
    var images: [String: String]
    var category: String
    var description: String
    
    //Info
    var phone: String
    var address: String
    var latitude: String
    var longitude: String
    var city: String
    var email: String
    var website: String
    
    //Opening hours
    var openingHours: String
    
    //Events
    var hasEvents: Bool
    
    //Followers
    var hasFollowers: Bool
    
    init?(with dictionary: [String : AnyObject]) {
        if let venueId = dictionary["id"] as? String, venueId != "" {
            self.id = venueId
            self.name = dictionary["name"] as? String ?? String()
            self.images = dictionary["images"] as? [String: String] ?? [String: String]()
            self.category = dictionary["category"] as? String ?? String()
            self.description = dictionary["description"] as? String ?? String()

            self.phone = dictionary["phone"] as? String ?? String()
            self.address = dictionary["address"] as? String ?? String()
            self.latitude = dictionary["latitude"] as? String ?? String()
            self.longitude = dictionary["longitude"] as? String ?? String()
            self.city = dictionary["city"] as? String ?? String()
            self.email = dictionary["email"] as? String ?? String()
            self.website = dictionary["website"] as? String ?? String()
            
            self.openingHours = dictionary["openingHours"] as? String ?? String()
            self.hasEvents = dictionary["hasEvents"] as? Bool ?? false
            self.hasFollowers = dictionary["hasFollowers"] as? Bool ?? false

        } else {
            print("Venue obj not created - id not valid")
            return nil
        }
    }
}
