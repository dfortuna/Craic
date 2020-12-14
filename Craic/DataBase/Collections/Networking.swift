//
//  FriendshipRequests.swift
//  Craic
//
//  Created by Denis Fortuna on 1/9/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

//This class keeps track of the user's interactions with othe people, saving the status as
//friends
//friendship request sent/received but stil pending
//following/not following

import Foundation
import RealmSwift

enum FriendshipStatus: String {
    case friendAndFollowing
    case friendButNotFollowing
    case notFriendButFollowing
    case requestSentAndFollowing
    case requestSentButNotFollowing
    case requestReceivedAndFollowing
    case requestReceivedButNotFollowing
}
    
@objcMembers class Networking: Object {
    dynamic var userID: String = ""
    dynamic var userName: String = ""
    dynamic var userProfilePicture: String = ""
    private dynamic var privateStatus = FriendshipStatus.friendAndFollowing.rawValue
    var status: FriendshipStatus {
        get { return FriendshipStatus(rawValue: privateStatus)!}
        set { privateStatus = newValue.rawValue }
    }
    
    override class func primaryKey() -> String? {
        "userID"
    }
    
    convenience init(userID: String, userName: String, userProfilePicture: String, status: FriendshipStatus){
        self.init()
        self.userID = userID
        self.userName = userName
        self.userProfilePicture = userProfilePicture
        self.status = status
    }
}
