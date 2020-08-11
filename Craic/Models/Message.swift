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
    var messageBetweenUsers: [String]
    
    var senderID: String
    var senderName: String
    var senderProfilePicture: String
    
    var receiverID: String
    var receiverName: String
    var receiverProfilePicture: String
    
    var threadTitle: String
    var text: String
    var numericDate: Int
    var stringDate: String
    
    //if new message, threadID should be equal to message id, messageNumber == 0
    // if its a reply message, threadID should be the same for all following replies,
    // messageNumber += messageBeenReplied.messageNumber + 1
    var threadID: String
    var replyingMessageID: String?
    var messageNumber: Int
    
    var messageType: String
    var eventID: String?
    var venueID: String?
    
    
    init?(with dictionary: [String : AnyObject]) {
        if let messageID = dictionary["id"] as? String, messageID != "",
           let sID = dictionary["senderID"] as? String, sID != "",
           let mBU = dictionary["messageBetweenUsers"] as? [String],
           let sName = dictionary["senderName"] as? String, sName != "",
           let sPicture = dictionary["senderProfilePicture"] as? String,
           let rID = dictionary["receiverID"] as? String, rID != "",
           let rName = dictionary["receiverName"] as? String, rName != "",
           let rPicture = dictionary["receiverProfilePicture"] as? String,
           let text = dictionary["text"] as? String, text != "",
           let nDate = dictionary["numericDate"] as? Int,
           let sDate = dictionary["stringDate"] as? String,
           let tID = dictionary["threadID"] as? String,
           let tTitle = dictionary["threadTitle"] as? String,
           let mN = dictionary["messageNumber"] as? Int,
           let mType = dictionary["messageType"] as? String, mType != "" {
            
            self.id = messageID
            self.senderID = sID
            self.messageBetweenUsers = mBU
            self.senderName = sName
            self.senderProfilePicture = sPicture
            self.receiverID = rID
            self.receiverName = rName
            self.receiverProfilePicture = rPicture
            self.text = text
            self.numericDate = nDate
            self.stringDate = sDate
            self.threadID = tID
            self.threadTitle = tTitle
            self.messageNumber = mN
            self.messageType = mType
            
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
    }
    
    init(withTitle threadTitle: String) {
        self.id = ""
        self.messageBetweenUsers = [""]
        self.senderName = ""
        self.senderID = ""
        self.senderProfilePicture = ""
        self.receiverID = ""
        self.receiverName = ""
        self.receiverProfilePicture = ""
        self.threadTitle = threadTitle
        self.text = ""
        self.numericDate = 0
        self.stringDate = ""
        self.threadID = ""
        self.messageNumber = 0
        self.messageType = ""
    }
}
