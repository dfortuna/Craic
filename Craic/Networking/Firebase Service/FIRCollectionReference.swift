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
    case userFollowers(ofUser: String)
    case userFeed(ofUser: String)
    case userFavorites(ofUser: String)
    case userAgenda(ofUser: String)
    
    case friendship
    case message
    case venue
    case event
    
    var path: String {
        switch self {
            case .metadata:
                return "Metadata"
            
            case .user:
                return "User"
            case .userFavorites(let user):
                return "User/\(user)/UserFavorites"
            case .userAgenda(let user):
                return "User/\(user)/UserAgenda"
            case .userFollowers(let user):
                return "User/\(user)/UserFollowers"
            case .userFeed(let user):
                return "User/\(user)/UserFeed"
           
            case .message:
                return "Message"
            case .friendship:            
                return "Friendship"
            case .venue:
                return "Venue"
            case .event:
                return "Event"
        }
    }
}
