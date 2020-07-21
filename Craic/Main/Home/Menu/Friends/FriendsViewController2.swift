//
//  FriendsViewController2.swift
//  Craic
//
//  Created by Denis Fortuna on 15/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

class FriendsViewController2: GenericListViewController<User, UserCollectionViewCell, UserProfileViewController> {

    override func fetchData() {
        guard let userID = objID else { return }
        firebaseService.fetchDocumentsByKeyword(from: .friendship,
                                                returning: Friendship.self,
                                                keyword: userID,
                                                field: "friends") { (result) in
                                                switch result {
                                                    case .success(let friendships):
                                                        let users = friendships.compactMap{ $0.getFriend(fromLoggedUserID: userID)
                                                        }
                                                        self.formatResult(forList: users)
                                                    case .failure(_):
                                                        Alert.somethingWentWrong.call(onViewController: self)
                                                    }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseService.removeListener(from: .friendship)
    }
}
