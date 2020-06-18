//
//  FIRCellInputObj.swift
//  Craic
//
//  Created by Denis Fortuna on 17/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

class FIRCellInputObj {
    //Object that wraps all inputs for UICollectionViewCells that conform to the FIRObjectCell protocol
    private let coreLocationService = CoreLocationService.shared
    
    //TODO: Realm Access
    private let realmService = false
    
    var event: Event?
    var venue: Venue?
    var user: User?
    var distance: String?
    var isFollowing: Bool?
    var isAttending: Bool?
    
    init?(withFIRObjectProtocol obj: FIRObjectProtocol) {
        // used in itemforRow(atIndexPath)
        switch obj {
        case is Venue:
            self.venue = obj as? Venue
            self.distance = coreLocationService.userDistanceToCoordinate(latitudeStr: venue?.latitude,
                                                                         longitudeStr: venue?.longitude)
            self.isFollowing = realmService
        case is Event:
            self.event = obj as? Event
            self.distance = coreLocationService.userDistanceToCoordinate(latitudeStr: event?.latitude,
                                                                        longitudeStr: event?.longitude)
            self.isAttending = realmService
        case is User:
            self.user = obj as? User
            self.isFollowing = realmService
        default:
            return nil
        }
    }
}
