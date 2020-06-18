//
//  Friend.swift
//  Project4
//
//  Created by Denis Fortuna on 12/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

//import Foundation
//    
//struct Friend {
//    
//    var friendshipID: String
//    var friendID: String
//    var isFavoriteFriendKey: String
//    var name: String
//    var profilePic: String
//    var isFavorite: Bool
//    
//    init?(friendship: Friendship, userID: String) {
//        self.friendshipID = friendship.id
//        if userID == friendship.f1Id {
//            self.name = friendship.f2Name
//            self.friendID = friendship.f2Id
//            self.profilePic = friendship.f2ProfilePicture
//            self.isFavorite = friendship.f2IsFavorite
//            self.isFavoriteFriendKey = "f2IsFavorite"
//        } else if userID == friendship.f2Id {
//            self.name = friendship.f1Name
//            self.friendID = friendship.f1Id
//            self.profilePic = friendship.f1ProfilePicture
//            self.isFavorite = friendship.f1IsFavorite
//            self.isFavoriteFriendKey = "f1IsFavorite"
//        } else {
//            return nil
//        }
//    }
//}
