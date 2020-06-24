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
        firebaseService.fetchWithListener(from: .venueFollowers(ofVenue: venueID),
                                          returning: User.self) { (result) in
                                            switch result {
                                            case .success(let users):
                                                self.formatResult(forList: users)
                                            case .failure(_):
                                                Alert.somethingWentWrong.call(onViewController: self)
                                            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let venueID = objID else { return }
        firebaseService.removeListener(from: .venueFollowers(ofVenue: venueID))
    }
}
