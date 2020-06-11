//
//  FIRCollectionReference.swift
//  Project4
//
//  Created by Denis Fortuna on 7/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

enum FIRCollectionsReference {
    case metadata
    
    case user
    case userFavorites(ofUser: String)
    case userFollowers(ofUser: String)
    case userMessages(ofUser: String)
    case userFeed(ofUser: String)
    case userEvents(ofUser: String)
    
    case friendship
    
    case venue
    case venueFollowers(ofVenue: String)
    case venueEvents(ofVenue: String)

    case event
    case eventAttendees(ofEvent: String)
    
    var path: String {
        switch self {
            case .metadata:
                return "Metadata"
            
            case .user:
                return "User"
            case .userFavorites(let user):
                return "User/\(user)/Favorites"
            case .userEvents(let user):
                return "User/\(user)/Agenda"
            case .userFollowers(let user):
                return "User/\(user)/Followers"
            case .userMessages(let user):
                return "User/\(user)/Messages"
            case .userFeed(let user):
                return "User/\(user)/Feed"
            
            case .friendship:            
                return "Friendship"

            case .venue:
                return "Venue"
            case .venueFollowers(let venue):
                return "Venue/\(venue)/Followers"
            case .venueEvents(let venue):
                return "Venue/\(venue)/Events"

            case .event:
                return "Event"
            case .eventAttendees(let event):
                return "Event/\(event)/Attendees"
        }
    }
}
