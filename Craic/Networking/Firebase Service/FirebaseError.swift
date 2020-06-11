//
//  FirebaseError.swift
//  Project4
//
//  Created by Denis Fortuna on 5/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

enum FirebaseError: Error {
    case userNotAuthenticated
    case documentNotCreated
    case documentNotFetched
    case documentNotFound
    case dataNotMerged
    case documentNotUpdated
    case documentNotDeleted

    var localizedDescription: String {
        switch self {
            case .userNotAuthenticated: return "User not authenticated"
            case .documentNotCreated: return "Error creating document"
            case .documentNotFetched: return "Error retriving data from Database"
            case .documentNotFound: return "Document does not exist"
            case .dataNotMerged: return "Error merging data"
            case .documentNotUpdated: return "Error updating document"
            case .documentNotDeleted: return "Error deleting document"
        }
    }
}
