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
    private let realmService = RealmService.shared
    
    var event: Event?
    var venue: Venue?
    var user: User?
    var userFavorites: UserFavorites?
    var userAgenda: UserAgenda?
    var distance: String?
    
    init?(withFIRObjectProtocol obj: FIRObjectProtocol) {
        // used in itemforRow(atIndexPath)
        switch obj {
        case is Venue:
            self.venue = obj as? Venue
            guard let v = self.venue else { return nil }
            self.venue = formatFollowingVenue(venue: v)
            self.distance = coreLocationService.userDistanceToCoordinate(latitudeStr: venue?.latitude,
                                                                         longitudeStr: venue?.longitude)
        case is Event:
            self.event = obj as? Event
            guard let e = self.event else { return nil }
            self.event = formatAttendingEvent(event: e)
            self.distance = coreLocationService.userDistanceToCoordinate(latitudeStr: event?.latitude,
                                                                        longitudeStr: event?.longitude)
            
        //write something here dude...
        case is UserAgenda:
            self.userAgenda = obj as? UserAgenda
            guard let ea = self.userAgenda else { return nil }
            self.userAgenda = formatUserAgenda(userAgenda: ea)
            self.distance = coreLocationService.userDistanceToCoordinate(latitudeStr: event?.latitude,
                                                                        longitudeStr: event?.longitude)
        //write something here dude...
        case is UserFavorites:
            self.userFavorites = obj as? UserFavorites
            guard let uf = self.userFavorites else { return nil }
            self.userFavorites = formatUserFavorites(userFavorite: uf)
            
        case is User:
            self.user = obj as? User
            guard let u = self.user else { return nil }
            self.user = formatFollowingUser(user: u)
        default:
            return nil
        }
    }
    
    func formatAttendingEvent(event: Event) -> Event {
        //Check if any events coming from Firebase had been added to the local Database already (by ATTENDING button)
        //if events is found, sets True to isAttending attribute before sending it to CellForItem
        var e = event
        if realmService.getDocument(PrimaryKey: e.id, fromCollection: .attendingEvent) != nil {
            e.isAttending = true
        } else {
            e.isAttending = false
        }
        return e
    }
    
    func formatFollowingVenue(venue: Venue) -> Venue {
        var v = venue
        if realmService.getDocument(PrimaryKey: v.id, fromCollection: .favoriteVenue) != nil {
            v.isFollowing = true
        } else {
            v.isFollowing = false
        }
        return v
    }
    
    func formatFollowingUser(user: User) -> User {
        var u = user
        if realmService.getDocument(PrimaryKey: u.id, fromCollection: .followingUser) != nil {
            u.isFollowing = true
        } else {
            u.isFollowing = false
        }
        return u
    }
    
    func formatUserFavorites(userFavorite: UserFavorites) -> UserFavorites {
        var uf = userFavorite
        if realmService.getDocument(PrimaryKey: uf.venueID, fromCollection: .favoriteVenue) != nil {
            uf.isFavorite = true
        } else {
            uf.isFavorite = false
        }
        return uf
    }
    
    func formatUserAgenda(userAgenda: UserAgenda) -> UserAgenda{
        var ua = userAgenda
        if realmService.getDocument(PrimaryKey: ua.eventId, fromCollection: .attendingEvent) != nil {
            ua.isAttending = true
        } else {
            ua.isAttending = false
        }
        return ua
    }
}
