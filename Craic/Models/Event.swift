//
//   .swift
//  Project4
//
//  Created by Denis Fortuna on 19/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

struct Event: FIRObjectProtocol {
    
    var id: String
    var name: String
    var images: [String:String]
    var category: String
    var description: String
    
    var phone: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var city: String?
    var email: String?
    var website: String?
    
    var hostID: String
    var hostName: String
    var hostProfileImage: String
    var price: String
    var date: String
    var time: String
    var hasAttendees: Bool
    
    init?(with dictionary: [String: AnyObject]) {
        if let eventId = dictionary["id"] as? String {
            self.id = eventId
            self.name = dictionary["name"] as? String ?? String()
            self.images = dictionary["images"] as? [String: String] ?? [String: String]()
            self.category = dictionary["category"] as? String ?? String()
            self.description = dictionary["description"] as? String ?? String()
            
            self.phone = dictionary["phone"] as? String ?? nil
            self.address = dictionary["address"] as? String ?? nil
            self.latitude = dictionary["latitude"] as? String ?? nil
            self.longitude = dictionary["longitude"] as? String ?? nil
            self.city = dictionary["city"] as? String ?? nil
            self.email = dictionary["email"] as? String ?? nil
            self.website = dictionary["website"] as? String ?? nil
            
            self.hostID = dictionary["hostID"] as? String ?? String()
            self.hostName = dictionary["hostName"] as? String ?? String()
            self.hostProfileImage = dictionary["hostProfileImage"] as? String ?? String()
            self.price = dictionary["price"] as? String ?? String()
            self.date = dictionary["date"] as? String ?? String()
            self.time = dictionary["time"] as? String ?? String()
            self.hasAttendees = dictionary["website"] as? Bool ?? false
            
        } else {
            print("Event obj not created - id not valid")
            return nil
        }
    }
}
