//
//  RealmService.swift
//  Craic
//
//  Created by Denis Fortuna on 18/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    let realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print()
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print()
        }
    }
    
    func delete<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print()
        }
    }
    
    func updateObject(ofPrimaryKey id: String,
                      withAttributes dic: [String: Any?],
                      fromCollection collType: RealmCollectionTypes) {
        guard let doc = getDocument(PrimaryKey: id, fromCollection: collType) else { return }
        update(doc, with: dic)
    }
    
    func deleteObject(ofPrimaryKey id: String, fromCollection collType: RealmCollectionTypes) {
        guard let doc = getDocument(PrimaryKey: id, fromCollection: collType) else { return }
        delete(doc)
    }
    
    func getDocument(PrimaryKey id: String, fromCollection collType: RealmCollectionTypes) -> Object? {
        return realm.object(ofType: collType.path, forPrimaryKey: id)
    }
}
