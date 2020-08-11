//
//  MessageType.swift
//  Project4
//
//  Created by Denis Fortuna on 15/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

enum MessageType: String {
    case eventInvitation = "eventInvitation" // segue to event profile
    case venueInvitation = "venueInvitation" // segue to venue profile
    case chatMessage = "chatMessage" // segue to message detail
    
    static func getType(type: String) -> MessageType? {
        switch type {
        case "eventInvitation":
            return .eventInvitation
        case "venueInvitation":
            return .eventInvitation
        case "chatMessage":
            return .chatMessage
        default:
            return nil
        }
    }
}
