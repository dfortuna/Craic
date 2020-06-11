//
//  Extensions.swift
//  Project4
//
//  Created by Denis Fortuna on 7/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation
import Firebase

enum NetworkingError: Error {
    case encodingError
}

extension Encodable {
    
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw NetworkingError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        return json
    }
}

extension DocumentSnapshot {
    
    func toObject<T: FIRObjectProtocol>(objectType: T.Type) -> T? {
        
        var firObjData = self.data() as! [String: AnyObject]
        
        firObjData["id"] = self.documentID as AnyObject  //TODO - check this
        let teste = objectType.init(with: firObjData)
        return teste
    }
}
