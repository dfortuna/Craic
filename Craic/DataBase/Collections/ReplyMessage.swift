//
//  ReplyMessage.swift
//  Craic
//
//  Created by Denis Fortuna on 21/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class ReplyMessage: Object {
    dynamic var messageID: String = ""
    dynamic var numericDate: Int = 0
    dynamic var thread: String = ""
    dynamic var replyingToID: String = ""
    dynamic var replyNumber: Int = 0
    dynamic var messageText: String = ""
    
    override class func primaryKey() -> String? {
        "messageID"
    }
    
    convenience init(messageID: String,
                     numericDate: Int,
                     thread: String,
                     replyingToID: String,
                     replyNumber: Int,
                     messageText: String){
        self.init()
        self.messageID = messageID
        self.numericDate = numericDate
        self.thread = thread
        self.replyingToID = replyingToID
        self.replyNumber = replyNumber
        self.messageText = messageText
    }
}
