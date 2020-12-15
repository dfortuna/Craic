//
//  FollowingUsers.swift
//  Craic
//
//  Created by Denis Fortuna on 19/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

enum FriendshipStatus: String {
    case friend = "friend"
    case notFriend = "notFriend"
    case pendingInvitationSent = "pendingInvitationSent"
    case pendingInvitationReceived = "pendingInvitationReceived"
    
    static func getCase(_ stringCase: String) -> FriendshipStatus {
        switch stringCase {
        case "friend":
            return .friend
        case "notFriend":
            return .notFriend
        case "pendingInvitationSent":
            return .pendingInvitationSent
        default:
            return pendingInvitationReceived
        }
    }
}

@objcMembers class DBUser: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var profilePicture: String = ""
    dynamic var friendshipStatus: String = ""
    dynamic var isFollowing: Bool = false
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(id: String,
                     name: String,
                     profilePicture: String,
                     isFollowing: Bool,
                     friendshipStatus: FriendshipStatus){
        self.init()
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.friendshipStatus = friendshipStatus.rawValue
        self.isFollowing = isFollowing
    }
}
