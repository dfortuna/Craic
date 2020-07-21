//
//  String+Extensions.swift
//  Craic
//
//  Created by Denis Fortuna on 20/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation

extension String {
    
    func convertToddMMMDateformat() -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        guard let ddMMMDate = dateFormat.date(from: self) else { return nil }
        dateFormat.dateFormat = "dd MMM"
        let ddMMMString = dateFormat.string(from: ddMMMDate)
        return ddMMMString
    }
}
