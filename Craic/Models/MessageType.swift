//
//  MessageType.swift
//  Project4
//
//  Created by Denis Fortuna on 15/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

enum MessageType: String {
    case eventInvitation = "eventInvitation" // segue to event profile (invitation cell)
    case venueInvitation = "venueInvitation" // segue to venue profile (invitation cell)
    case chatMessage = "chatMessage" // segue to message detail (chat cell)
    case friendshipRequest = "friendshipRequest" //segue to user profile (friendship request cell)
    
    static func getType(type: String) -> MessageType? {
        switch type {
        case "eventInvitation":
            return .eventInvitation
        case "venueInvitation":
            return .venueInvitation
        case "chatMessage":
            return .chatMessage
        case "friendshipRequest":
            return .friendshipRequest
        default:
            return nil
        }
    }
}
