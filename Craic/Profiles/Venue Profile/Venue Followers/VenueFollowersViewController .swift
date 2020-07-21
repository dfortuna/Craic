//
//  VenueFollowersViewController .swift
//  Craic
//
//  Created by Denis Fortuna on 22/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueFollowersViewController: GenericListViewController<User, UserCollectionViewCell, UserProfileViewController> {

    override func fetchData() {
        guard let venueID = objID else { return }
        firebaseService.collectionGroupQuery(collectionID: "UserFavorites",
                                             field: "venueID",
                                             queryOperator: "==",
                                             value: venueID,
                                             returning: UserFavorites.self) { (result) in
                                                switch result {
                                                case .success(let uf):
                                                    let users = uf.compactMap{ $0.getUser()}
                                                    self.formatResult(forList: users)
                                                case .failure(_):
                                                    Alert.somethingWentWrong.call(onViewController: self)
                                                }
        }
    }
}
