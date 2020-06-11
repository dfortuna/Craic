//
//  FacebookUserProtocol.swift
//  Project4
//
//  Created by Denis Fortuna on 8/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

protocol FIRObjectProtocol: Codable {
    var id: String {get}
    init?(with dictionary: [String: AnyObject])
    
}

