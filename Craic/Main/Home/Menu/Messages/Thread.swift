//
//  Thread.swift
//  Craic
//
//  Created by Denis Fortuna on 6/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

struct Thread {
    var id: String
    var replyList: [Int: Message]
    var numericDateLastMessage: Int
    var stringDateLastMessage: String
    var numberOfUnreadMessages: Int
}
