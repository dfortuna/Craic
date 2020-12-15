//
//  SentMessage.swift
//  Craic
//
//  Created by Denis Fortuna on 21/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

//For messages saved locally: Sent messages and read messages.
@objcMembers class DBMessage: Object {
    dynamic var messageID: String = ""
    
    override class func primaryKey() -> String? {
        "messageID"
    }
    
    convenience init(messageID: String){
        self.init()
        self.messageID = messageID
    }
    
}
