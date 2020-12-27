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
        addUserIDToReceiverPendingListOnRemoteDatabase(senderID: sender.id, receiverID: receiver.id)
        addReceiverIDToUserPendingListOnRemoteDatabase(senderID: sender.id, receiverID: receiver.id)
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
    
    private func addUserIDToReceiverPendingListOnRemoteDatabase(senderID: String, receiverID: String) {
        firestore.updateFieldArrayUnion(objectID: receiverID,
                                         in: .user,
                                         fieldName: "pendingFriendshipUserIds",
                                         fieldValue: senderID)
    }
    
    private func addReceiverIDToUserPendingListOnRemoteDatabase(senderID: String, receiverID: String) {
        firestore.updateFieldArrayUnion(objectID: senderID,
                                         in: .user,
                                         fieldName: "sentFriendshipInvitationIds",
                                         fieldValue: receiverID)
    }

    
    //MARK: - DECLINE FRIENDSHIP
    func declineFriendshipInvitation(receiverID: String, senderID: String) {
        removeFriendshipFromRemoteDataBase(receiverID: receiverID, senderID: senderID)
        removeUserIDFromReceiverPendingListOnRemoteDatabase(senderID: senderID, receiverID: receiverID)
        removeReceiverIDFromUserPendingListOnRemoteDatabase(senderID: senderID, receiverID: receiverID)
    }
    
    private func removeFriendshipFromRemoteDataBase(receiverID: String, senderID: String) {
        let friendshipID = Friendship.getFriendshipID(forUserID1: receiverID, andUserID2: senderID)
        firestore.delete(documentID: friendshipID, in: .friendship) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("friendship deleted")
            }
        }
    }
    
    private func removeUserIDFromReceiverPendingListOnRemoteDatabase(senderID: String, receiverID: String) {
        firestore.updateFieldArrayRemove(objectID: receiverID,
                                         in: .user,
                                         fieldName: "receivedFriendshipInvitationIds",
                                         fieldValue: senderID)
    }
    
    private func removeReceiverIDFromUserPendingListOnRemoteDatabase(senderID: String, receiverID: String) {
        firestore.updateFieldArrayRemove(objectID: senderID,
                                         in: .user,
                                         fieldName: "sentFriendshipInvitationIds",
                                         fieldValue: receiverID)
    
    }

    //MARK: - ACCEPT FRIENDSHIP
    
    func acceptFriendshipInvitation(receiver: User, senderID: String) {
        updateFriendshipOnRemoteDataBase(receiver: receiver.id, senderID: senderID)
        addUserAsFriendToLocalDB(receiver: receiver)
        removeUserIDFromReceiverPendingListOnRemoteDatabase(senderID: senderID, receiverID: receiver.id)
        removeReceiverIDFromUserPendingListOnRemoteDatabase(senderID: senderID, receiverID: receiver.id)
    }
    
    private func updateFriendshipOnRemoteDataBase(receiver: String, senderID: String) {
        let friendshipID = Friendship.getFriendshipID(forUserID1: receiver, andUserID2: senderID)
        let approval: String? = nil
        firestore.update(objectID: friendshipID,
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
    
    //MARK: - UNFRIEND
    func deleteFriendship(receiverID: String, senderID: String) {
        removeFriendshipFromRemoteDataBase(receiverID: receiverID, senderID: senderID)
        removeFriendFromLocalDataBase(userID: receiverID)
    }
    
    private func removeFriendFromLocalDataBase(userID: String) {
        realm.deleteObject(ofPrimaryKey: userID, fromCollection: .dBUser)
    }
}


