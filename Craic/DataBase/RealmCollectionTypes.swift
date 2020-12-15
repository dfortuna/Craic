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
    case dBVenue
    case dBEvent
    case dBUser
    case dBMessage
    
    var path: Object.Type{
        switch self {
        case .dBVenue:
            return DBVenue.self
        case .dBEvent:
            return DBEvent.self
        case .dBUser:
            return DBUser.self
        case .dBMessage:
            return DBMessage.self
        }
    }
}
