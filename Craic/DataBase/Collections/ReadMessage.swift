//
//  ReadMessage.swift
//  Craic
//
//  Created by Denis Fortuna on 20/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class ReadMessage: Object {
    dynamic var messageID: String = ""
    dynamic var senderName: String = ""
    dynamic var senderProfilePicture: String = ""
    
    override class func primaryKey() -> String? {
        "messageID"
    }
    
    convenience init(messageID: String, senderName: String, senderProfilePicture: String){
        self.init()
        self.messageID = messageID
        self.senderName = senderName
        self.senderProfilePicture = senderProfilePicture
    }
}
