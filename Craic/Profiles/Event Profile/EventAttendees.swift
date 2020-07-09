//
//  EventAttendees.swift
//  Craic
//
//  Created by Denis Fortuna on 1/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

class EventAttendees: GenericListViewController<User, UserCollectionViewCell, UserProfileViewController> {

    override func fetchData() {
        guard let eventID = objID else { return }
        firebaseService.fetchWithListener(from: .eventAttendees(ofEvent: eventID),
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
        guard let eventID = objID else { return }
        firebaseService.removeListener(from: .venueEvents(ofVenue: eventID))
    }
}
