//
//  FriendshipProtocol.swift
//  Craic
//
//  Created by Denis Fortuna on 16/12/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//
import Foundation

enum FriendshipError: Error  {
    case cantResendIvitation
    
    var localizedDescription: String {
        switch self {
        case .cantResendIvitation:
            return "Friendship invitation has already been sent"
        }
    }
}


protocol FriendshipProtocol { }

extension FriendshipProtocol {
    
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
    
    //MARK: - SEND FRIENDSHIP
    func sendFriendshipInvitation(sender: User, receiver: User) throws {
        try checkIfDoubleInvitation(sender: sender, receiver: receiver)
        addFriendshipToRemoteDataBase(sender: sender, receiver: receiver)
        addUserIDToReceiverPendingListOnRemoteDatabase(sender: sender, receiver: receiver)
        addReceiverIDToUserPendingListOnRemoteDatabase(sender: sender, receiver: receiver)
    }
    
    private func checkIfDoubleInvitation(sender: User, receiver: User) throws {
        //check if friendship invite has already been sent
        let ids = receiver.receivedFriendshipInvitationIds.filter{ $0 == sender.id }
        if ids.first != nil {
            throw FriendshipError.cantResendIvitation
        }
    }
    
    private func addFriendshipToRemoteDataBase(sender: User, receiver: User) {
        let friendship = Friendship(friend1: sender, friend2: receiver, pendingOfApprovalId: receiver.id)
        firestore.create(for: friendship, in: .friendship) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("friendship added")
            }
        }
    }
    
    private func addUserIDToReceiverPendingListOnRemoteDatabase(sender: User, receiver: User) {
        var pendingList = receiver.receivedFriendshipInvitationIds
        pendingList.append(sender.id)
        firestore.update(objectID: receiver.id,
                         in: .user,
                         dataToUpdate: ["pendingFriendshipUserIds": pendingList as AnyObject]) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(_):
                                print("UserID added")
                            }
        }
    }
    
    private func addReceiverIDToUserPendingListOnRemoteDatabase(sender: User, receiver: User) {
        var pendingList = receiver.sentFriendshipInvitationIds
        pendingList.append(receiver.id)
        firestore.update(objectID: receiver.id,
                         in: .user,
                         dataToUpdate: ["sentFriendshipInvitationIds": pendingList as AnyObject]) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(_):
                                print("ReceiverID added")
                            }
        }
    }

    
    //MARK: - DECLINE FRIENDSHIP
    func declineFriendshipInvitation(friendship: Friendship, receiver: User, senderID: String) {
        removeFriendshipFromRemoteDataBase(friendship: friendship)
        removeIDFromPendingFriendshipListOnRemoteDatabase(senderID: senderID, receiver: receiver)
    }
    
    private func removeFriendshipFromRemoteDataBase(friendship: Friendship) {
        firestore.delete(documentID: friendship.id, in: .friendship) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("friendship deleted")
            }
        }
    }
    
    private func removeIDFromPendingFriendshipListOnRemoteDatabase(senderID: String,  receiver: User) {
        let filteredList = receiver.receivedFriendshipInvitationIds.filter {$0 != senderID }
        firestore.update(objectID: receiver.id,
                         in: .user,
                         dataToUpdate: ["pendingFriendshipUserIds": filteredList as AnyObject]) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(_):
                                print("Pending friendship list updated")
                            }
        }
    }

    //MARK: - ACCEPT FRIENDSHIP
    
    func acceptFriendshipInvitation(friendship: Friendship, receiver: User, senderID: String) {
        updateFriendshipOnRemoteDataBase(friendship: friendship)
        removeIDFromPendingFriendshipListOnRemoteDatabase(senderID: senderID, receiver: receiver)
    }
    
    private func updateFriendshipOnRemoteDataBase(friendship: Friendship) {
        let approval: String? = nil
        firestore.update(objectID: friendship.id,
                         in: .friendship,
                         dataToUpdate: ["pendingOfApprovalId": approval as AnyObject]) { (result) in
                            switch result {
                            case .failure(let error):
                                print(error)
                            case .success(_):
                                print("friendship deleted")
                            }
        }
    }
    
    private func addUserAsFriendToLocalDB(receiver: User) {
        let dbUser = DBUser(id: receiver.id,
                            name: receiver.name,
                            profilePicture: receiver.profileImage,
                            isFollowing: receiver.isFollowing ?? false)
        realm.delete(dbUser)
    }
    
    //MARK: - INSPECT FRIENDSHIP
    
    func inspectFriendship(friendship: Friendship, loggedUserID id: String) {
        //Store friend in local database if it is not there yet
        guard let friend = friendship.getFriend(fromLoggedUserID: id) else { return }
        if realm.getDocument(PrimaryKey: friend.id, fromCollection: .dBUser) == nil {
            let dbUser = DBUser(id: friend.id,
                                name: friend.name,
                                profilePicture: friend.profileImage,
                                isFollowing: friend.isFollowing ?? false)
            realm.create(dbUser)
        }
    }
}
