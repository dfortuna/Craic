//
//  FollowingUsers.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class FollowingUser: Object {
    dynamic var userID: String = ""
    dynamic var friendName: String = ""
    dynamic var friendProfilePicture: String = ""
    
    override class func primaryKey() -> String? {
        "userID"
    }
    
    convenience init(userID: String, friendName: String, friendProfilePicture: String){
        self.init()
        self.userID = userID
        self.friendName = friendName
        self.friendProfilePicture = friendProfilePicture
    }
}
