//
//  User.swift
//  Project4
//
//  Created by Denis Fortuna on 5/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

struct User: FIRObjectProtocol {
    var id: String
    var email: String
    var name: String
    var gender: String
    var firstName: String
    var lastName: String
    var profileImage = String() 
    var isFollowing: Bool?
    
    // list of userIds with friendship invitations sent to the user but pending of approval
    var receivedFriendshipInvitationIds: [String]
    
    // list of userIds with friendship invitations sent by the user but pending of approval
    var sentFriendshipInvitationIds: [String]
    
    init?(with dictionary: [String: AnyObject]) {
        if let userId = dictionary["id"] as? String, userId != "" {
            self.id = userId
            self.email = dictionary["email"] as? String ?? String()
            self.name = dictionary["name"] as? String ?? String()
            self.gender = dictionary["gender"] as? String ?? String()
            self.firstName = dictionary["first_name"] as? String ?? String()
            self.lastName = dictionary["last_name"] as? String ?? String()
            if let picture = dictionary["picture"] as? [String : AnyObject]  {
                if let picData = picture["data"] as?  [String : AnyObject] {
                    self.profileImage = picData["url"] as? String ?? String()
                }
            }
            if let profileImage = dictionary["profileImage"] as? String {
                self.profileImage = profileImage
            }
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
        receivedFriendshipInvitationIds = [""]
    }
    
    init?(friendship: Friendship, userID: String) {
        if userID == friendship.f1Id {
            self.name = friendship.f2Name
            self.id = friendship.f2Id
            self.profileImage = friendship.f2ProfilePicture
        } else if userID == friendship.f2Id {
            self.name = friendship.f1Name
            self.id = friendship.f1Id
            self.profileImage = friendship.f1ProfilePicture
        } else {
            return nil
        }
        self.email = ""
        self.gender = ""
        self.firstName = ""
        self.lastName = ""
        receivedFriendshipInvitationIds = [""]
    }
}
