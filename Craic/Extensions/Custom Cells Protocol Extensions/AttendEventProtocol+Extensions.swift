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
    
// *** Adding Event to Agenda ************************************************************************************
    
    func attendEvent(forEvent event: Event, user: User){
        let userAgenda = UserAgenda(forUser: user, andEvent: event)
        
        addEventToAgendaOnRemoteDatabase(forUserAgenda: userAgenda)
        addEventToAgendaOnLocalDatabase(forUserAgenda: userAgenda)
        firestore.incrementField(field: "attendees",
                                 documentID: event.id,
                                 incrementBy: 1,
                                 collectionReference: .event)
    }
    
    private func addEventToAgendaOnRemoteDatabase(forUserAgenda aEvent: UserAgenda) {
        firestore.create(for: aEvent, in: .userAgenda(ofUser: aEvent.userId)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! 
            }
        }
    }
    
    private func addEventToAgendaOnLocalDatabase(forUserAgenda aEvent: UserAgenda) {
        //VER REALM EVENT
        let realmEvent = DBEvent(id: aEvent.id,
                                 name: aEvent.eventName,
                                 profilePicture: aEvent.eventProfilePicture)
        realm.create(realmEvent)
    }
    
// *** Deleting Event from Agenda **********************************************************************************
    
    func unattendedEvent(forEvent event: Event, user: User){
        
        //look for AttendingEvent on local DB to retrive id created on remote DB
        guard let agendaEvent = realm.getDocument(PrimaryKey: event.id, fromCollection: .dBEvent) as? DBEvent else { return }
        
        //used id retrived above to delete event from User/UserAgenda
        deleteEventFromAgendaOnRemoteDatabase(forAgendaEventId: agendaEvent.id, userId: user.id)
        
        //delete event from local DB
        deleteEventFromAgendaOnLocalDatabase(event: agendaEvent)
        
        //decrese by 1 attendees field on remote DB
        firestore.incrementField(field: "attendees",
                                 documentID: event.id,
                                 incrementBy: -1,
                                 collectionReference: .event)
    }
    
    private func deleteEventFromAgendaOnRemoteDatabase(forAgendaEventId agendaId: String, userId: String) {
        firestore.delete(documentID: agendaId,
                         in: .userAgenda(ofUser: userId)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO!
            }
        }
    }
    
    private func deleteEventFromAgendaOnLocalDatabase(event: DBEvent) {
        realm.delete(event)
    }
}

