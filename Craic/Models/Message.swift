//
//  Message.swift
//  Project4
//
//  Created by Denis Fortuna on 13/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct Message: FIRObjectProtocol {
    
//compulsory fields:
    var id: String
    var date: String
    var title: String
    var isRead: Bool
    var senderID: String
    var senderName: String
    var messageType: String
  
//optional fields:
    var subTitle: String
    var longMessage: String
    var senderProfilePic: String
    var eventID: String
    
    
    init?(with dictionary: [String : AnyObject]) {
        if let messageId = dictionary["id"] as? String, messageId != "",
           let messageDate = dictionary["date"] as? String, messageId != "",
           let messageTitle = dictionary["title"] as? String, messageId != "",
           let messageIsRead = dictionary["isRead"] as? Bool,
           let messageSenderID = dictionary["senderID"] as? String, messageId != "",
           let messageSenderName = dictionary["senderName"] as? String, messageId != "",
           let messageType = dictionary["messageType"] as? String, messageType != "" {
            self.id = messageId
            self.date = messageDate
            self.title = messageTitle
            self.subTitle = dictionary["subTitle"] as? String ?? String()
            self.longMessage = dictionary["longMessage"] as? String ?? String()
            self.isRead = messageIsRead
            self.senderID = messageSenderID
            self.senderName = messageSenderName
            self.senderProfilePic = dictionary["senderProfilePic"] as? String ?? String()
            self.messageType = messageType
            self.eventID = dictionary["eventID"] as? String ?? String()
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
    }
}
