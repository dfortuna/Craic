//
//  FavoriteVenueProtocol+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 6/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

protocol FavoriteVenueProtocol {

}

extension FavoriteVenueProtocol {
    private var firestore: FirebaseService {
        get {
            return FirebaseService.shared
        }
    }
    
    func isFavorite(userID: String) -> Bool {
        //TODO! - Realm Access
        return false
    }
    
    func followVenue(forVenue venue: Venue, user: User){
        addUserAsFollowerOnRemoteDatabase(forVenue: venue, user: user)
        addVenueAsFavoriteOnRemoteDatabase(forVenue: venue, user: user)
        addVenueAsFavoriteOnLocalDatabase(forVenue: venue, user: user)
    }
    
    private func addUserAsFollowerOnRemoteDatabase(forVenue venue: Venue, user: User){
        firestore.create(for: user, in: .venueFollowers(ofVenue: venue.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func addVenueAsFavoriteOnRemoteDatabase(forVenue venue : Venue, user: User) {
        firestore.create(for: venue, in: .userFavorites(ofUser: user.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
        
    }
    
    private func addVenueAsFavoriteOnLocalDatabase(forVenue venue : Venue, user: User) {
        
    }
    
    func unfollowVenue(forVenue venue: Venue, user: User){
        deleteUserAsFollowerOnRemoteDatabase(forVenue: venue, user: user)
        deleteVenueAsFavoriteOnRemoteDatabase(forVenue: venue, user: user)
        deleteVenueAsFavoriteOnLocalDatabase(forVenue: venue, user: user)
    }
    
    private func deleteUserAsFollowerOnRemoteDatabase(forVenue venue: Venue, user: User){
        firestore.delete(documentID: user.id, in: .venueFollowers(ofVenue: venue.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func deleteVenueAsFavoriteOnRemoteDatabase(forVenue venue: Venue, user: User) {
        firestore.delete(documentID: venue.id, in: .userFavorites(ofUser: user.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func deleteVenueAsFavoriteOnLocalDatabase(forVenue venue: Venue, user: User) {
        
    }
    
}
