//
//  FriendsViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 15/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

class FriendsViewController: GenericListViewController<User, UserCollectionViewCell, UserProfileViewController> {

    override func fetchData() {
        guard let userID = objID else { return }
        firebaseService.fetchDocumentsByKeyword(from: .friendship,
                                                returning: Friendship.self,
                                                keyword: userID,
                                                field: "friends") { (result) in
                                                switch result {
                                                    case .success(let friendships):
                                                        self.formatFriendships(friendships: friendships, userID: userID)
                                                    case .failure(_):
                                                        Alert.somethingWentWrong.call(onViewController: self)
                                                    }
        }
    }
    
    private func formatFriendships(friendships: [Friendship], userID: String) {
        var users = [User]()
        for friendship in friendships {
            guard let user = friendship.getFriend(fromLoggedUserID: userID) else { return }
            users.append(user)
            inspectFriendship(friendship: friendship, loggedUserID: userID)
        }
        self.formatResult(forList: users)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseService.removeListener(from: .friendship)
    }
}
