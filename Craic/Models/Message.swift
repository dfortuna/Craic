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
    
    var senderID: String
    var senderName: String
    var senderProfilePicture: String
    
    var receiverID: String
    var receiverName: String
    var receiverProfilePicture: String
    
    var text: String
    var numericDate: Int
    var stringDate: String
    
    var replyingMessageID: String?
    var messageNumber: Int
    
    var messageType: String
    var eventID: String?
    var venueID: String?
    
    
    init?(with dictionary: [String : AnyObject]) {
        if let messageID = dictionary["id"] as? String, messageID != "",
           let sID = dictionary["senderID"] as? String, sID != "",
           let sName = dictionary["senderName"] as? String, sName != "",
           let sPicture = dictionary["senderProfilePicture"] as? String, sPicture != "",
           let rID = dictionary["receiverID"] as? String, rID != "",
           let rName = dictionary["receiverName"] as? String, rName != "",
           let rPicture = dictionary["receiverProfilePicture"] as? String, rPicture != "",
           let text = dictionary["text"] as? String, text != "",
           let nDate = dictionary["numericDate"] as? Int,
           let sDate = dictionary["stringDate"] as? String,
           let mN = dictionary["messageNumber"] as? Int,
           let mType = dictionary["messageType"] as? String, mType != "" {
            
            self.id = messageID
            self.senderID = sID
            self.senderName = sName
            self.senderProfilePicture = sPicture
            self.receiverID = rID
            self.receiverName = rName
            self.receiverProfilePicture = rPicture
            self.text = text
            self.numericDate = nDate
            self.stringDate = sDate
            self.messageNumber = mN
            self.messageType = mType
            
        } else {
            print("Message obj not created - id not valid")
            return nil
        }
    }
}
