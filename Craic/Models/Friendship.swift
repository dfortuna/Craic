//
//  UserFriend.swift
//  Project4
//
//  Created by Denis Fortuna on 9/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

struct Friendship: FIRObjectProtocol {

    var friends: [String]
    var id: String
    var pendingOfApprovalId: String? = nil
    
    //Data from user with smallest id (Friend 1)
    var f1Id: String
    var f1Name: String
    var f1ProfilePicture: String
    var f1IsFavorite: Bool

    //Data from user with highest id (Friend 2)
    var f2Id: String
    var f2Name: String
    var f2ProfilePicture: String
    var f2IsFavorite: Bool
    
    init(friend1: User, friend2: User, pendingOfApprovalId: String?) {
        self.pendingOfApprovalId = pendingOfApprovalId
        friends = [friend1.id, friend2.id]
        if friend1.id < friend2.id {
            self.id = "\(friend1.id)_\(friend2.id)"
            
            self.f1Id = friend1.id
            self.f1Name = friend1.name
            self.f1ProfilePicture = friend1.profileImage
            self.f1IsFavorite = false
            
            self.f2Id = friend2.id
            self.f2Name = friend2.name
            self.f2ProfilePicture = friend2.profileImage
            self.f2IsFavorite = false
        } else {
            self.id = "\(friend2.id)_\(friend1.id)"
            
            self.f1Id = friend2.id
            self.f1Name = friend2.name
            self.f1ProfilePicture = friend2.profileImage
            self.f1IsFavorite = false
            
            self.f2Id = friend1.id
            self.f2Name = friend1.name
            self.f2ProfilePicture = friend1.profileImage
            self.f2IsFavorite = false
        }
    }
    

    init?(with dictionary: [String: AnyObject]) {
        
        //Format Friendship for insert in database
        if let userId = dictionary["userId"] as? String,
            let userName = dictionary["userName"] as? String,
            
            let friendId = dictionary["id"] as? String,
            let friendName = dictionary["name"] as? String {
            
            friends = [friendId, userId]
            
            if friendId < userId {
                
                self.id = "\(friendId)_\(userId)"
                self.f1Id = friendId
                self.f1Name = friendName
                self.f1ProfilePicture = dictionary["profileImage"] as? String ?? String()
                self.f1IsFavorite = false
                
                self.f2Id = userId
                self.f2Name = userName
                self.f2ProfilePicture = dictionary["userProfilePicture"] as? String ?? String()
                self.f2IsFavorite = false
            } else {
                self.id = "\(userId)_\(friendId)"
                self.f1Id = userId
                self.f1Name = userName
                self.f1ProfilePicture = dictionary["userProfilePicture"] as? String ?? String()
                self.f1IsFavorite = false
                
                self.f2Id = friendId
                self.f2Name = friendName
                self.f2ProfilePicture = dictionary["profileImage"] as? String ?? String()
                self.f2IsFavorite = false
            }
            
        } else {
            
            if let friendshipID = dictionary["id"] as? String {
                self.id = friendshipID
            } else { self.id = "" }
            
            self.friends = [""]
            
            if let f1Id = dictionary["f1Id"] as? String {
                self.f1Id = f1Id
            } else {self.f1Id = ""}
            
            if let f1Name = dictionary["f1Name"] as? String {
                self.f1Name = f1Name
            } else { self.f1Name = ""}
            
            if let f1ProfilePicture = dictionary["f1ProfilePicture"] as? String {
                self.f1ProfilePicture = f1ProfilePicture
            } else {  self.f1ProfilePicture = ""}
            
            if let f1IsFavorite = dictionary["f1IsFavorite"] as? Bool {
                self.f1IsFavorite = f1IsFavorite
            } else { self.f1IsFavorite = false}
            
            if let f2Id = dictionary["f2Id"] as? String{
                self.f2Id = f2Id
            } else { self.f2Id = ""}
            
            if let f2Name = dictionary["f2Name"] as? String {
                self.f2Name = f2Name
            } else { self.f2Name = ""}
            
            if let f2ProfilePicture = dictionary["f2ProfilePicture"] as? String{
                self.f2ProfilePicture = f2ProfilePicture
            } else { self.f2ProfilePicture = ""}
            
            if let f2IsFavorite = dictionary["f2IsFavorite"] as? Bool {
                self.f2IsFavorite = f2IsFavorite
            } else { self.f2IsFavorite = false}
        }
    }
    
    func getFriend(fromLoggedUserID userID: String) -> User? {
        if userID == f1Id {
            return User(with: ["id": f2Id,
                               "name": f2Name,
                               "profileImage": f2ProfilePicture] as [String: AnyObject])
        } else {
            return User(with: ["id": f1Id,
                               "name": f1Name,
                               "profileImage": f1ProfilePicture] as [String: AnyObject])
        }
    }
    
    static func getFriendshipID(forUserID1 user1: String, andUserID2 user2: String) -> String {
        if user1 < user2 {
            return "\(user1)_\(user2)"
        } else {
            return "\(user2)_\(user1)"
        }
    }
}
