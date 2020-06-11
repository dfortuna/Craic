//
//  EventCell.swift
//  Project4
//
//  Created by Denis Fortuna on 18/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct EventCell: FIRObjectProtocol {
    
    var id: String
    var name: String
    var latitude: String
    var longitude: String
    var price: String
    var date: String
    var time: String
    var images: String
    
    init?(with dictionary: [String: AnyObject]) {
        if let eventId = dictionary["id"] as? String {
            self.id = eventId
            self.name = dictionary["name"] as? String ?? String()
            self.latitude = dictionary["latitude"] as? String ?? String()
            self.longitude = dictionary["longitude"] as? String ?? String()
            self.price = dictionary["price"] as? String ?? String()
            self.date = dictionary["date"] as? String ?? String()
            self.time = dictionary["time"] as? String ?? String()
            self.images = dictionary["images"] as? String ?? String()
            
        } else {
            print("Event obj not created - id not valid")
            return nil
        }
    }
}
