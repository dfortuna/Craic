//
//  VenueEventsViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 17/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueEventsViewController: GenericListViewController<Event, EventCollectionViewCell, EventProfileViewController> {

    override func fetchData() {
        guard let venueID = objID else { return }
        firebaseService.queryDocuments(from: .event,
                                       returning: Event.self,
                                       operatorKeyValue: [(key:"hostID", op:"==", value: venueID)],
                                       orderByField: "",
                                       descending: false) { (result) in
                                        switch result {
                                        case .success(let events):
                                            self.formatResult(forList: events)
                                        case .failure(_):
                                            Alert.somethingWentWrong.call(onViewController: self)
                                        }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseService.removeListener(from: .event)
    }
}
