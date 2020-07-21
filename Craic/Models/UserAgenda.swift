//
//  UserAgenda.swift
//  Craic
//
//  Created by Denis Fortuna on 11/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct UserAgenda: FIRObjectProtocol {
    var id: String
    
    //Event data for listing in Menu's Agenda
    var eventId: String
    var eventName: String
    var eventDate: String
    var eventLatitude: String
    var eventLongitude: String
    var eventPrice: String
    var eventProfilePicture: String
    var isAttending: Bool
    
    //User Data for Listing on Event's Profile
    var userId: String
    var userName: String
    var userProfilePicture: String
    
    init?(with dictionary: [String : AnyObject]) {
        
        if let eventId = dictionary["id"] as? String, eventId != "" {
            self.id = eventId

            self.eventId = dictionary["eventId"] as? String ?? ""
            self.eventName = dictionary["eventName"] as? String ?? ""
            self.eventDate = dictionary["eventDate"] as? String ?? ""
            self.eventLatitude = dictionary["eventLatitude"] as? String ?? ""
            self.eventLongitude = dictionary["eventLongitude"] as? String ?? ""
            self.eventPrice = dictionary["eventPrice"] as? String ?? ""
            self.eventProfilePicture = dictionary["eventProfilePicture"] as? String ?? ""
            self.isAttending = true
            
            self.userId = dictionary["userID"] as? String ?? ""
            self.userName = dictionary["userName"] as? String ?? ""
            self.userProfilePicture = dictionary["userProfilePicture"] as? String ?? ""
        } else {
            print("Favorite event obj not created - id not valid")
            return nil
        }
    }
    
    init(forUser user: User, andEvent event: Event) {
        self.id = UUID().uuidString
        self.eventId = event.id
        self.eventName = event.name
        self.eventDate = event.date
        self.eventPrice = event.price
        self.eventProfilePicture = event.images["0"] ?? ""
        self.eventLatitude = event.latitude ?? ""
        self.eventLongitude = event.longitude ?? ""
        self.isAttending = true
        
        self.userId = user.id
        self.userName = user.name
        self.userProfilePicture = user.profileImage
    }
    
    func getEvent() -> Event? {
        Event(with: ["id": eventId,
                     "name": eventName,
                     "date": eventDate,
                     "price": eventPrice,
                     "latitude": eventLatitude,
                     "longitude": eventLongitude,
                     "isFavorite": true,
                     "images": ["0": eventProfilePicture]] as [String: AnyObject])
    }
    
    func getUser() -> User? {
        User(with: ["id": userId,
                    "name": userName,
                    "profileImage": userProfilePicture] as [String: AnyObject])
    }
}
