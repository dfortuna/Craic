//
//  User.swift
//  Project4
//
//  Created by Denis Fortuna on 5/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

struct User: FIRObjectProtocol {
    var id: String
    var email: String
    var name: String
    var gender: String
    var firstName: String
    var lastName: String
    var profileImage = String()
    
    init?(with dictionary: [String: AnyObject]) {
        if let userId = dictionary["id"] as? String, userId != "" {
            self.id = userId
            self.email = dictionary["email"] as? String ?? String()
            self.name = dictionary["name"] as? String ?? String()
            self.gender = dictionary["gender"] as? String ?? String()
            self.firstName = dictionary["first_name"] as? String ?? String()
            self.lastName = dictionary["last_name"] as? String ?? String()
            if let picture = dictionary["picture"] as? [String : AnyObject]  {
                if let picData = picture["data"] as?  [String : AnyObject] {
                    self.profileImage = picData["url"] as? String ?? String()
                }
            }
            if let profileImage = dictionary["profileImage"] as? String {
                self.profileImage = profileImage
            }
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
    }
}
