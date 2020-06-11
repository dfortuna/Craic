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
    case shortMessage = "shortMessage" // does not segue to another View Controller
    case advertising = "advertising" // segue to message detail
    case inform = "inform"  // segue to message detail
    
    static func getType(type: String) -> MessageType? {
        switch type {
        case "eventInvitation":
            return .eventInvitation
        case "shortMessage":
            return .shortMessage
        case "advertising":
            return .advertising
        case "inform":
            return .inform
        default:
            return nil
        }
    }
}
