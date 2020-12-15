//
//  AttendingEvent.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBEvent: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var profilePicture = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(id: String, name: String, profilePicture: String) {
        self.init()
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
    }
}
