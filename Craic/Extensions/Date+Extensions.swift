//
//  Date+Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 17/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

extension Date {
    
    func getNumericDate() -> Int? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMddHHmmss"
        guard let numericDate = Int(dateFormat.string(from: self)) else { return nil }
        return numericDate
    }
    
    func getStringDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormat.string(from: self)
    }
}
