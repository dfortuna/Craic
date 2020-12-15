//
//  FavoriteVenueProtocol+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 6/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

protocol FavoriteVenueProtocol { }

extension FavoriteVenueProtocol {
    
    private var realm: RealmService {
        get {
            return RealmService.shared
        }
    }
    
    private var firestore: FirebaseService {
        get {
            return FirebaseService.shared
        }
    }
    
// *** Adding Venue as Favorite ************************************************************************************
    
    func followVenue(forVenue venue: Venue, user: User){
        let favoriteVenue = UserFavorites(forUser: user, andVenue: venue)
        
        addVenueAsFavoriteOnOnRemoteDatabase(forUserFavorite: favoriteVenue)
        addVenueAsFavoriteOnLocalDatabase(forUserFavorite: favoriteVenue)
        firestore.incrementField(field: "followers",
                                 documentID: venue.id,
                                 incrementBy: 1,
                                 collectionReference: .venue)
    }
    
    private func addVenueAsFavoriteOnOnRemoteDatabase(forUserFavorite fVenue: UserFavorites){
        firestore.create(for: fVenue, in: .userFavorites(ofUser: fVenue.userID)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func addVenueAsFavoriteOnLocalDatabase(forUserFavorite fVenue: UserFavorites) {
        let realmEvent = DBVenue(id: fVenue.id,
                                 name: fVenue.venueName,
                                 profilePicture: fVenue.venueProfilePicture)

        realm.create(realmEvent)
    }
    
// *** Deleting Venue as Favorite **********************************************************************************
    
    func unfollowVenue(forVenue venue: Venue, user: User){
        
        //look for FavoriteVenue on local DB to retrive id created on remote DB
        guard let favoriteVenue = realm.getDocument(PrimaryKey: venue.id, fromCollection: .dBVenue) as? DBVenue else { return }
        
        //used id retrived above to delete event from User/UserFavorites
        deleteVenueAsFavoriteOnRemoteDatabase(forFavoriteVenueId: favoriteVenue.id, userId: user.id)
        
        //delete event from local DB
        deleteVenueAsFavoriteOnLocalDatabase(venue: favoriteVenue)
        
        //decrese by 1 attendees field on remote DB
        firestore.incrementField(field: "followers",
                                 documentID: venue.id,
                                 incrementBy: -1,
                                 collectionReference: .venue)
    }
    
    private func deleteVenueAsFavoriteOnRemoteDatabase(forFavoriteVenueId fvenue: String, userId: String){
        
        
        firestore.delete(documentID: fvenue, in: .userFavorites(ofUser: userId)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
        
    private func deleteVenueAsFavoriteOnLocalDatabase(venue: DBVenue) {
        realm.delete(venue)
    }
    
}
