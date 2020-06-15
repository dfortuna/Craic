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
    
    private var firestore: FirebaseService {
        get {
            return FirebaseService.shared
        }
    }
    
    func isUserAttendingEvent(userID: String) -> Bool {
        //TODO! - Realm Access
        return false
    }
    
    func attendEvent(forEvent event: Event, user: User){
        addUserAsAttendeeOnRemoteDatabase(forEvent: event, user: user)
        addEventOnUsersAttendingListOnRemoteDatabase(forEvent: event, user: user)
        addEventOnUsersAttendingListOnLocalDatabase(forEvent: event, user: user)
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
                print() //TODO! - add @escaping
            }
        }
        
    }
    
    private func addEventOnUsersAttendingListOnLocalDatabase(forEvent event : Event, user: User) {
        
    }
    
    func unattendedEvent(forEvent event: Event, user: User){
        deleteUserAsAttendeeOnRemoteDatabase(forEvent: event, user: user)
        deleteEventOnUsersAttendingListOnRemoteDatabase(forEvent: event, user: user)
        deleteEventOnUsersAttendingListOnLocalDatabase(forEvent: event, user: user)
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
    
    private func deleteEventOnUsersAttendingListOnLocalDatabase(forEvent event: Event, user: User) {
        
    }
    
}

