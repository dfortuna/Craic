//
//  SearchType.swift
//  Craic
//
//  Created by Denis Fortuna on 16/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

struct SearchData {
    let cellID: String
    let cellHeight: CGFloat
    let profileStoryboardName: String
    let viewControllerID: String
}

enum SearchType {
    case users
    case events
    case venues
    
    func getCellData() -> SearchData {
        switch self {
        case .users:
            return SearchData(cellID: "UserCollectionViewCell",
                              cellHeight: 120,
                              profileStoryboardName: "UserProfile",
                              viewControllerID: "UserProfileViewController")

        case .events:
            return SearchData(cellID: "EventCollectionViewCell",
                              cellHeight: 120,
                              profileStoryboardName: "EventProfile",
                              viewControllerID: "EventProfileViewController")
            
        case .venues:
            return SearchData(cellID: "VenueCollectionViewCell",
                              cellHeight: 120,
                              profileStoryboardName: "VenueProfile",
                              viewControllerID: "VenueProfileViewController")
        }
    }
}
