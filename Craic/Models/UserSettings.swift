//
//  UserDefaults.swift
//  Project4
//
//  Created by Denis Fortuna on 9/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

class UserSettings {
    
    private var userDataKey = "loggedUser"
    private var userData: [String: String] {
        get {
            if let returnValue = UserDefaults.standard.object(forKey: userDataKey) as? [String: String] {
                return returnValue
            } else {
                return [String: String]()
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDataKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getLoggedUser() -> User? {
        let formatedData = userData as [String: AnyObject]
        return User(with: formatedData) 
    }
    
    func setLoggedUser(forUser user: User) {
        let id = user.id
        let name = user.name
        let profilePicture = user.profileImage
        let userInfo = ["id": id,
                        "name": name,
                        "profileImage": profilePicture]
        userData = userInfo
    }
}
