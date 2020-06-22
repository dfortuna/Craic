//
//  AttendingEvent.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class AttendingEvent: Object {
    dynamic var eventID = ""
    dynamic var eventName = ""
    dynamic var eventProfilePicture = ""
    
    override class func primaryKey() -> String? {
        "eventID"
    }
    
    convenience init(eventID: String, eventName: String, eventProfilePicture: String) {
        self.init()
        self.eventID = eventID
        self.eventName = eventName
        self.eventProfilePicture = eventProfilePicture
    }
}
