//
//  AttendEventProtocol+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 8/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

protocol AttendEventProtocol {
    
}

extension AttendEventProtocol {
    
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
    
    func attendEvent(forEvent event: Event, user: User){
        addUserAsAttendeeOnRemoteDatabase(forEvent: event, user: user)
        addEventOnUsersAttendingListOnRemoteDatabase(forEvent: event, user: user)
        addToAttendingEventOnLocalDatabase(forEvent: event)
//        if !event.hasAttendees {
//            updateHasAttendees(forEvent: event)
//        }
    }
    
    private func addUserAsAttendeeOnRemoteDatabase(forEvent event: Event, user: User){
        firestore.create(for: user, in: .eventAttendees(ofEvent: event.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func addEventOnUsersAttendingListOnRemoteDatabase(forEvent event : Event, user: User) {
        firestore.create(for: event, in: .userEvents(ofUser: user.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - error handling
            }
        }
    }
    
    private func addToAttendingEventOnLocalDatabase(forEvent event : Event) {
        //VER REALM EVENT
        let realmEvent = AttendingEvent(eventID: event.id, eventName: event.name, eventProfilePicture: event.images["0"] ?? "")
        realm.create(realmEvent)
    }
    
//    private func updateHasAttendees(forEvent event: Event) {
//        firestore.updateMergeData(objectID: event.id, in: .event, dataToUpdate: ["hasAttendees": true]) { (result) in
//            switch result {
//            case .success(_):
//                break
//            case .failure(_):
//                print() //TODO! - error handling
//            }
//        }
//    }
    
    
    func unattendedEvent(forEvent event: Event, user: User){
        deleteUserAsAttendeeOnRemoteDatabase(forEvent: event, user: user)
        deleteEventOnUsersAttendingListOnRemoteDatabase(forEvent: event, user: user)
        removeFromAttendingEventOnLocalDatabase(forEvent: event)
    }
    
    private func deleteUserAsAttendeeOnRemoteDatabase(forEvent event: Event, user: User){
        firestore.delete(documentID: user.id, in: .eventAttendees(ofEvent: event.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func deleteEventOnUsersAttendingListOnRemoteDatabase(forEvent event: Event, user: User) {
        firestore.delete(documentID: event.id, in: .userEvents(ofUser: user.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func removeFromAttendingEventOnLocalDatabase(forEvent event: Event) {
        realm.deleteObject(ofPrimaryKey: event.id, fromCollection: .attendingEvent)
    }
}

