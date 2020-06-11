//
//  UserCell.swift
//  Project4
//
//  Created by Denis Fortuna on 18/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct UserCell: FIRObjectProtocol {
    var id: String
    var name: String
    var profileImage: String
    
    init?(with dictionary: [String: AnyObject]) {
        if let userId = dictionary["id"] as? String, userId != "" {
            self.id = userId
            self.name = dictionary["name"] as? String ?? String()
            self.profileImage = dictionary["profileImage"] as? String ?? String()
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
    }
}
