//
//  FacebookUser.swift
//  Project4
//
//  Created by Denis Fortuna on 8/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

struct FacebookUser {
    var id: String
    var email: String
    var name: String
    var gender: String
    var firstName: String
    var lastName: String
    var friends = [String]()
    var userPicURL = String()
    
    init(with dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        if let picture = dictionary["picture"] as? [String : AnyObject]  {
            if let picData = picture["data"] as?  [String : AnyObject] {
                self.userPicURL = picData["url"] as? String ?? ""
            }
        }
        if let friends = dictionary["friends"] as? [String : AnyObject] {
            if let friendsData = friends["data"] as? [[String: String]] {
                for friend in friendsData {
                    if let friendID = friend["id"] {
                        self.friends.append(friendID)
                    }
                }
            }
        }
    }
}
