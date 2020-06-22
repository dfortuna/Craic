//
//  FollowUserProtocol+Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 8/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

protocol FollowUserProtocol {

}

extension FollowUserProtocol {
    
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
    
    func followUser(forFriend friend: User, loggedUser: User){
        addUserAsFollowerOnRemoteDatabase(forFriend: friend, loggedUser: loggedUser)
        addUserAsFollowerOnLocalDatabase(forFriend: friend)
    }
    
    private func addUserAsFollowerOnRemoteDatabase(forFriend friend: User, loggedUser: User){
        firestore.create(for: loggedUser, in: .userFollowers(ofUser: friend.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func addUserAsFollowerOnLocalDatabase(forFriend friend : User) {
        let realmEvent = FollowingUser(userID: friend.id, friendName: friend.name, friendProfilePicture: friend.profileImage)
        realm.create(realmEvent)
    }
    
    func unfollowUser(forFriend friend: User, loggedUser: User){
        deleteUserAsFollowerOnRemoteDatabase(forFriend: friend, loggedUser: loggedUser)
        deleteUserAsFollowerOnLocalDatabase(forFriend: friend, loggedUser: loggedUser)
    }
    
    private func deleteUserAsFollowerOnRemoteDatabase(forFriend friend: User, loggedUser: User){
        firestore.delete(documentID: loggedUser.id, in: .userFollowers(ofUser: friend.id)) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(_):
                print() //TODO! - add @escaping
            }
        }
    }
    
    private func deleteUserAsFollowerOnLocalDatabase(forFriend user: User, loggedUser: User) {
        realm.deleteObject(ofPrimaryKey: user.id, fromCollection: .followingUser)
    }
    
}


