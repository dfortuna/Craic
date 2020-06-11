//
//  Feed.swift
//  Project4
//
//  Created by Denis Fortuna on 4/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

enum FeedType: String {
    case venueNewEvent = "venueNewEvent" //Post promoting a new event (should segue way to the Event Profile)
    case friendsFollowingVenue = "friendsFollowingVenue" //should segue way to the venue profile
    case friendsAttendingEvent = "friendsAttendingEvent" //should segue way to Event Profile
}

struct Feed: FIRObjectProtocol {
    
    //Feed Document Data
    var id: String
    var feedType: String
    var postTitle: String
    var postingDate: Int
    var postDescription: String
    var friendsInCommon: [String: [String: String]]?
    
    //Venue/Event common data
    var name: String
    var images: [String: String]
    var category: String
    var description: String
    
    var phone: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var city: String?
    var email: String?
    var website: String?
    
    //Event only Data
    var eventID: String?
    var hostID: String?
    var hostName: String?
    var hostProfileImage: String?
    var eventPrice: String?
    var eventDate: String?
    var eventTime: String?
    var hasAttendees: Bool?
    
    //Venue
    var venueID: String?
    var openingHours: String?
    var hasEvents: Bool?
    var hasFollowers: Bool?
    
    init?(with dictionary: [String : AnyObject]) {
        if let id = dictionary["id"] as? String,
            let feedType = dictionary["feedType"] as? String{
            self.id = id
            self.feedType = feedType
    
            self.postTitle = dictionary["postTitle"] as? String ?? String()
            self.postingDate = dictionary["postingDate"] as? Int ?? 0
            self.postDescription = dictionary["postDescription"] as? String ?? String()
            self.friendsInCommon = dictionary["friendsInCommon"] as? [String: [String: String]] ?? nil
            
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
            
            self.eventID = dictionary["eventID"] as? String ?? nil
            self.hostID = dictionary["hostID"] as? String ?? nil
            self.hostName = dictionary["hostName"] as? String ?? nil
            self.hostProfileImage = dictionary["hostProfileImage"] as? String ?? nil
            self.eventPrice = dictionary["eventPrice"] as? String ?? nil
            self.eventDate = dictionary["eventDate"] as? String ?? nil
            self.eventTime = dictionary["eventTime"] as? String ?? nil
            self.hasAttendees = dictionary["website"] as? Bool ?? nil
            
            self.venueID = dictionary["venueID"] as? String ?? nil
            self.openingHours = dictionary["openingHours"] as? String ?? nil
            self.hasEvents = dictionary["hasEvents"] as? Bool ?? nil
            self.hasFollowers = dictionary["hasFollowers"] as? Bool ?? nil

        } else {
            return nil
        }
    }
    
    
}
