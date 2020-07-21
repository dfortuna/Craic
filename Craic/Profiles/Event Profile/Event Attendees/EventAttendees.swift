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
        firebaseService.collectionGroupQuery(collectionID: "UserAgenda",
                                             field: "eventId",
                                             queryOperator: "==",
                                             value: eventID,
                                             returning: UserAgenda.self) { (result) in
                                                switch result {
                                                case .success(let ua):
                                                    let attendees = ua.compactMap{ $0.getUser() }
                                                    self.formatResult(forList: attendees)
                                                case .failure(_):
                                                    Alert.somethingWentWrong.call(onViewController: self)
                                                }
        }
    }
}
