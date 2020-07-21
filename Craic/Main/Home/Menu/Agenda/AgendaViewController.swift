//
//  AgendaViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 15/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

class AgendaViewController: GenericListViewController<Event, EventCollectionViewCell, EventProfileViewController> {

    override func fetchData() {
        guard let userId = objID else { return }
//        firebaseService.fetchDocumentsByKeyword(from: .userAgenda(ofUser: userId),
//                                                returning: Event.self,
//                                                keyword: userID,
//                                                field: "friends") { (result) in
//                                                switch result {
//                                                    case .success(let friendship):
//                                                        let friends = friendship.compactMap {
//                                                            User(friendship: $0, userID: userID)
//                                                        }
//                                                        self.formatResult(forList: friends)
//                                                    case .failure(_):
//                                                        Alert.somethingWentWrong.call(onViewController: self)
//                                                    }
//        }
        
        firebaseService.fetchWithListener(from: .userAgenda(ofUser: userId),
                                          returning: UserAgenda.self) { (result) in
                                            switch result {
                                                case .success(let userAganda):
                                                    let events = userAganda.compactMap { $0.getEvent() }
                                                    self.formatResult(forList: events)
                                                case .failure(_):
                                                    Alert.somethingWentWrong.call(onViewController: self)
                                                }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let userId = objID else { return }
        firebaseService.removeListener(from: .userAgenda(ofUser: userId))
    }
}
