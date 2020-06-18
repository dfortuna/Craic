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
        firebaseService.fetchWithListener(from: .venueEvents(ofVenue: venueID),
                                          returning: Event.self) { (result) in
                                            switch result {
                                            case .success(let events):
                                                self.formatResult(forList: events)
                                            case .failure(_):
                                                print()
                                                //TODO! -  Message view (no venues to show)
                                            }
        }
    }
}

