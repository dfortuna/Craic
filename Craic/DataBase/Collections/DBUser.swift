//
//  FollowingUsers.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBUser: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var profilePicture: String = ""
    dynamic var isFollowing: Bool = false
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(id: String,
                     name: String,
                     profilePicture: String,
                     isFollowing: Bool){
        self.init()
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.isFollowing = isFollowing
    }
}
