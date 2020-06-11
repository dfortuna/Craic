//
//  Metadata.swift
//  Project4
//
//  Created by Denis Fortuna on 22/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct Metadata: FIRObjectProtocol{
    var id: String
    let appDatabaseVersion: Double
    let cities: [String]
    
    init?(with dictionary: [String : AnyObject]) {
        self.id = dictionary["id"] as? String ?? String()
        self.appDatabaseVersion = dictionary["databaseVersion"] as? Double ?? Double()
        self.cities = dictionary["cities"] as? [String] ?? [String]()
    }
}

