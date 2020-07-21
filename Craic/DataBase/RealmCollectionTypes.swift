//
//  RealmCollectionTypes.swift
//  Craic
//
//  Created by Denis Fortuna on 20/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmCollectionTypes {
    case favoriteVenue
    case attendingEvent
    case followingUser
    case message
    case replyMessage
    
    var path: Object.Type{
        switch self {
        case .favoriteVenue:
            return FavoriteVenue.self
        case .attendingEvent:
            return AttendingEvent.self
        case .followingUser:
            return FollowingUser.self
        case .message:
            return ReadMessage.self
        case .replyMessage:
            return ReplyMessage.self
        }
    }
}
