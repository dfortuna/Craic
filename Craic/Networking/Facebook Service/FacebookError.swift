//
//  NetworkingError.swift
//  Project4
//
//  Created by Denis Fortuna on 5/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation

enum FacebookError: Error {
    case authError
    case facebookLogin
    
    var localizedDescription: String {
        switch self {
        case .authError: return "Error Auth Database"
        case .facebookLogin: return "Facebook login failed"
        }
    }
}
